-- Load NvChad defaults
require("nvchad.configs.lspconfig").defaults()

local servers = {
    html = {},

    -- линт-диагностики и code actions от ruff (форматирование — через conform)
    ruff = {},

    basedpyright = {
        before_init = function(_, config)
            local venv_python = (config.root_dir or "") .. "/.venv/bin/python"
            if vim.uv.fs_stat(venv_python) then
                config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                    python = { pythonPath = venv_python },
                })
            end
        end,
    },

    gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, { "go.mod", "go.work", ".git" }))
        end,
        settings = {
            gopls = {
                analyses = { shadow = true },
                staticcheck = true,
                gofumpt = true,
                completeUnimported = true,
                usePlaceholders = true,
            },
        },
    },

    templ = {
        cmd = { "templ", "lsp" },
        filetypes = { "templ" },
        root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, { "go.work", "go.mod", ".git" }))
        end,
    },

    -- PHP: phpantom_lsp (ранее intelephense). cmd/filetypes/root_markers берём
    -- из nvim-lspconfig (lsp/phpantom_lsp.lua), настройки сервера — в
    -- ~/.config/phpantom_lsp/.phpantom.toml (phpantom/ в этом репо) и
    -- per-project .phpantom.toml
    phpantom_lsp = {
        -- NvChad в своём on_init сбрасывает semanticTokensProvider для всех
        -- серверов; phpantom отдаёт контекстные токены (параметры,
        -- deprecated-ссылки, статика) — перекрываем пустым on_init,
        -- чтобы оставить их включёнными
        on_init = function() end,
    },
}

for name, opts in pairs(servers) do
    vim.lsp.config(name, opts)
    vim.lsp.enable(name)
end

-- code lens и inlay hints в nvim выключены по умолчанию; для phpantom они
-- дают счётчики референсов/имплементаций и типы параметров — как в Zed
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("phpantom_extras", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "phpantom_lsp" then
            return
        end
        -- фильтр только по bufnr: с client_id vim.lsp._capability.enable ставит
        -- лишь client-level маркер, а is_enabled требует ещё и buffer-level
        vim.lsp.codelens.enable(true, { bufnr = args.buf })
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end,
})

-- лензы phpantom используют клиентскую команду editor.action.showReferences
-- (VS Code-style, аргументы [uri, position, Location[]]) — nvim её не знает,
-- поэтому раскладываем локации в quickfix и показываем в Trouble
vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
    local locations = command.arguments and command.arguments[3] or {}
    if vim.tbl_isempty(locations) then
        vim.notify("Референсов не найдено", vim.log.levels.INFO)
        return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local items = vim.lsp.util.locations_to_items(locations, client and client.offset_encoding or "utf-16")
    vim.fn.setqflist({}, " ", { title = command.title or "References", items = items })

    if pcall(require, "trouble") then
        vim.cmd "Trouble qflist open"
    else
        vim.cmd "botright copen"
    end
end
