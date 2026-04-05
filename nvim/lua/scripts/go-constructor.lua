-- Генерация конструктора Go-структуры через Treesitter
-- Поставь курсор на struct, вызови :GoCtor

-- Множество нод-типов, которые являются типами полей в Go treesitter grammar
local type_node_kinds = {
    type_identifier = true,
    pointer_type = true,
    slice_type = true,
    map_type = true,
    array_type = true,
    interface_type = true,
    channel_type = true,
    function_type = true,
    qualified_type = true,
    struct_type = true,
    generic_type = true,
}

--- Первая буква в нижний регистр: Name -> name, ID -> iD
--- @param s string
--- @return string
local function lcfirst(s)
    if #s == 0 then
        return s
    end
    return s:sub(1, 1):lower() .. s:sub(2)
end

--- Поиск ближайшего type_declaration вверх по дереву от курсора
--- @return TSNode|nil
local function find_type_declaration()
    local node = vim.treesitter.get_node()
    while node do
        if node:type() == "type_declaration" then
            return node
        end
        node = node:parent()
    end
end

--- Найти первый дочерний нод заданного типа
--- @param node TSNode
--- @param kind string
--- @return TSNode|nil
local function find_child(node, kind)
    for child in node:iter_children() do
        if child:type() == kind then
            return child
        end
    end
end

--- Извлечь type_spec из type_declaration
--- @param type_decl TSNode
--- @return TSNode|nil
local function get_type_spec(type_decl)
    return find_child(type_decl, "type_spec")
end

--- Извлечь имя структуры и нод struct_type из type_spec
--- @param type_spec TSNode
--- @param bufnr integer
--- @return string|nil name
--- @return TSNode|nil struct_body
local function get_struct_name_and_body(type_spec, bufnr)
    local name, body = nil, nil
    for child in type_spec:iter_children() do
        local kind = child:type()
        if kind == "type_identifier" then
            name = vim.treesitter.get_node_text(child, bufnr)
        elseif kind == "struct_type" then
            body = child
        end
    end
    return name, body
end

--- Извлечь поля структуры из struct_type.
--- Обрабатывает:
---   - обычные поля (Name string)
---   - множественные имена (Host, Port string)
---   - embedded поля (Config, *log.Logger) — пропускаются с предупреждением
--- @param struct_body TSNode
--- @param bufnr integer
--- @return table fields — массив {name, type}
--- @return integer skipped_embedded — количество пропущенных embedded-полей
local function extract_fields(struct_body, bufnr)
    local field_list = find_child(struct_body, "field_declaration_list")
    if not field_list then
        return {}, 0
    end

    local fields = {}
    local skipped_embedded = 0

    for fd in field_list:iter_children() do
        if fd:type() == "field_declaration" then
            local names = {}
            local field_type = nil

            for fc in fd:iter_children() do
                local kind = fc:type()
                if kind == "field_identifier" then
                    table.insert(names, vim.treesitter.get_node_text(fc, bufnr))
                elseif type_node_kinds[kind] and not field_type then
                    field_type = vim.treesitter.get_node_text(fc, bufnr)
                end
            end

            if #names == 0 and field_type then
                -- embedded поле (нет field_identifier, только тип)
                skipped_embedded = skipped_embedded + 1
            elseif #names > 0 and field_type then
                for _, fn in ipairs(names) do
                    table.insert(fields, { name = fn, type = field_type })
                end
            end
        end
    end

    return fields, skipped_embedded
end

--- Проверить, существует ли уже конструктор NewXxx в буфере
--- @param bufnr integer
--- @param ctor_name string — например "NewUser"
--- @return boolean
local function constructor_exists(bufnr, ctor_name)
    local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local pattern = "func%s+" .. vim.pesc(ctor_name) .. "%s*%("
    for _, line in ipairs(buf_lines) do
        if line:match(pattern) then
            return true
        end
    end
    return false
end

--- Сгенерировать строки конструктора
--- @param struct_name string — имя структуры как в исходнике
--- @param fields table — массив {name, type}
--- @return string ctor_name — имя конструктора (NewXxx)
--- @return table lines — массив строк для вставки
local function generate_constructor(struct_name, fields)
    local cap_name = struct_name:sub(1, 1):upper() .. struct_name:sub(2)
    local ctor_name = "New" .. cap_name

    local params = {}
    local assigns = {}
    local seen_params = {}

    for _, field in ipairs(fields) do
        local param = lcfirst(field.name)

        -- Защита от коллизий: если поля Name и name дадут одинаковый param
        if seen_params[param] then
            param = param .. "_"
        end
        seen_params[param] = true

        table.insert(params, param .. " " .. field.type)
        table.insert(assigns, "\t\t" .. field.name .. ": " .. param .. ",")
    end

    local lines = {
        "",
        "func " .. ctor_name .. "(" .. table.concat(params, ", ") .. ") *" .. struct_name .. " {",
        "\treturn &" .. struct_name .. "{",
    }
    for _, a in ipairs(assigns) do
        table.insert(lines, a)
    end
    table.insert(lines, "\t}")
    table.insert(lines, "}")

    return ctor_name, lines
end

--- Определить, нужна ли пустая строка-разделитель перед вставкой
--- @param bufnr integer
--- @param insert_row integer — 0-based строка вставки
--- @return boolean
local function needs_blank_separator(bufnr, insert_row)
    local total = vim.api.nvim_buf_line_count(bufnr)
    if insert_row >= total then
        return true
    end
    local next_line = vim.api.nvim_buf_get_lines(bufnr, insert_row, insert_row + 1, false)[1]
    if next_line and next_line:match "^%s*$" then
        return false
    end
    return true
end

vim.api.nvim_create_user_command("GoCtor", function()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Проверка filetype
    if vim.bo[bufnr].filetype ~= "go" then
        vim.notify("GoCtor: only works in Go files", vim.log.levels.WARN)
        return
    end

    -- Поиск type_declaration
    local type_decl = find_type_declaration()
    if not type_decl then
        vim.notify("GoCtor: put cursor on a struct definition", vim.log.levels.WARN)
        return
    end

    -- Извлечение type_spec
    local type_spec = get_type_spec(type_decl)
    if not type_spec then
        vim.notify("GoCtor: could not find type_spec in declaration", vim.log.levels.WARN)
        return
    end

    -- Имя и тело структуры
    local struct_name, struct_body = get_struct_name_and_body(type_spec, bufnr)
    if not struct_name then
        vim.notify("GoCtor: could not parse struct name", vim.log.levels.WARN)
        return
    end
    if not struct_body then
        vim.notify("GoCtor: " .. struct_name .. " is not a struct", vim.log.levels.WARN)
        return
    end

    -- Парсинг полей
    local fields, skipped_embedded = extract_fields(struct_body, bufnr)
    if #fields == 0 then
        local msg = "GoCtor: struct " .. struct_name .. " has no named fields"
        if skipped_embedded > 0 then
            msg = msg .. " (" .. skipped_embedded .. " embedded field(s) skipped)"
        end
        vim.notify(msg, vim.log.levels.WARN)
        return
    end

    -- Генерация конструктора
    local ctor_name, lines = generate_constructor(struct_name, fields)

    -- Проверка идемпотентности
    if constructor_exists(bufnr, ctor_name) then
        vim.notify("GoCtor: " .. ctor_name .. "() already exists in this file", vim.log.levels.WARN)
        return
    end

    -- Определяем позицию вставки
    local _, _, end_row = type_decl:end_()

    -- Убираем лишнюю пустую строку-разделитель если она не нужна
    if not needs_blank_separator(bufnr, end_row) then
        table.remove(lines, 1) -- убираем ведущую ""
    end

    -- Вставка
    vim.api.nvim_buf_set_lines(bufnr, end_row, end_row, false, lines)

    -- Уведомление
    local msg = "GoCtor: " .. ctor_name .. "() created"
    if skipped_embedded > 0 then
        msg = msg .. " (" .. skipped_embedded .. " embedded field(s) skipped)"
    end
    vim.notify(msg, vim.log.levels.INFO)
end, {})
