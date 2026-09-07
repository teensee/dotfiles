-- Скретч-файлы: та же папка и те же шаблоны, что у Zed-тасков
-- (zed/tasks/scratch/) — одна скретч-система на оба редактора.
-- :Scratch <ext> — создать скретч, :Scratch без аргумента — выбор из списка.

local base = vim.fn.expand "~/Programming/scratches"

local templates_dir = (function()
    for _, dir in ipairs {
        "~/.config/zed/tasks/scratch/_templates",
        "~/.dotfiles/zed/tasks/scratch/_templates",
    } do
        local expanded = vim.fn.expand(dir)
        if vim.fn.isdirectory(expanded) == 1 then
            return expanded
        end
    end
end)()

-- ext → имя шаблона (соответствие как в zed/tasks.json)
local templates = {
    php = "php.tpl",
    go = "go.tpl",
    sql = "sql.tpl",
    json = "json.tpl",
    yaml = "yaml.tpl",
    md = "markdown.tpl",
    sh = "shell.tpl",
    py = "python.tpl",
    ts = "typescript.tpl",
    http = "http.tpl",
    txt = "txt.tpl",
    hurl = "hurl.tpl",
}

local exts = vim.tbl_keys(templates)
table.sort(exts)

--- @param name string|nil
--- @return string|nil
local function read_template(name)
    if not (templates_dir and name) then
        return nil
    end
    local f = io.open(templates_dir .. "/" .. name, "r")
    if not f then
        return nil
    end
    local text = f:read "*a"
    f:close()
    return text
end

--- Первый свободный номер для пути по формату (например ".../scratch_%d.py")
--- @param fmt string
--- @return integer n
--- @return string path
local function next_free(fmt)
    local n = 1
    while vim.uv.fs_stat(fmt:format(n)) do
        n = n + 1
    end
    return n, fmt:format(n)
end

--- Go: каждый скретч — изолированный модуль scratch_N/ с go.mod
local function new_go_scratch()
    local go_base = base .. "/go"
    vim.fn.mkdir(go_base, "p")
    local n, dir = next_free(go_base .. "/scratch_%d")
    vim.fn.mkdir(dir, "p")

    local main = dir .. "/main.go"
    local f = assert(io.open(main, "w"))
    f:write(read_template "go.tpl" or "package main\n\nfunc main() {\n}\n")
    f:close()

    local result = vim.system({ "go", "mod", "init", "scratch_" .. n }, { cwd = dir }):wait()
    if result.code ~= 0 then
        vim.notify("Scratch: go mod init failed: " .. (result.stderr or ""), vim.log.levels.WARN)
    end
    vim.cmd.edit(main)
end

--- @param ext string
local function new_scratch(ext)
    if not templates[ext] then
        vim.notify("Scratch: unknown type '" .. ext .. "' (" .. table.concat(exts, ", ") .. ")", vim.log.levels.WARN)
        return
    end
    if ext == "go" then
        return new_go_scratch()
    end

    vim.fn.mkdir(base, "p")
    local _, path = next_free(base .. "/scratch_%d." .. ext)
    local f = assert(io.open(path, "w"))
    f:write(read_template(templates[ext]) or "")
    f:close()
    if ext == "sh" then
        vim.uv.fs_chmod(path, 493) -- 0755
    end
    vim.cmd.edit(path)
end

vim.api.nvim_create_user_command("Scratch", function(cmd)
    if cmd.args ~= "" then
        new_scratch(cmd.args)
    else
        vim.ui.select(exts, { prompt = "Scratch type" }, function(choice)
            if choice then
                new_scratch(choice)
            end
        end)
    end
end, {
    nargs = "?",
    complete = function()
        return exts
    end,
    desc = "Создать скретч-файл в ~/Programming/scratches",
})
