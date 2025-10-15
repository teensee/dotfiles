-- Load NvChad defaults
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = {
    html = {},

    -- cssls = { cmd = { "cssls" } },
    gopls = {
        cmd = { "gopls" },
        root_pattern = lspconfig.util.root_pattern("go.mod", ".git"),
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
            gopls = {
                analyses = {
                    shadow = true, -- check shadowing
                },
                staticcheck = true, -- Enable staticcheck
                gofumpt = true, -- включаю автоформатирвоание
                completeUnimported = true,
                usePlaceholders = true,
            },
        },
    },
    templ = {
        default_config = {
            cmd = { "templ", "lsp" },
            filetypes = { "templ" },
            root_dir = function(fname)
                return lspconfig.util.root_pattern("go.work", "go.mod", ".git")(fname)
            end,
        },
        docs = {
            description = [[
https://templ.guide

The official language server for the templ HTML templating language.
]],
        },
    },
    pyright = {},

    sqlls = {
        cmd = { "sql-language-server", "up", "--method", "stdio" },
        filetypes = { "sql", "mysql" },
        root_dir = function(fname)
            return lspconfig.util.root_pattern(".git", ".")(fname)
        end,
        settings = {
            sqlLanguageServer = {
                lint = {
                    rules = {
                        "align-column-to-the-first",
                        "column-new-line",
                        "linebreak-after-clause-keyword",
                        "reserved-word-case",
                        "space-surrounding-operators",
                        "where-clause-new-line",
                        "align-where-clause-to-the-first",
                    },
                },
            },
        },
    },

    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/phpactor.lua#L7
    -- phpactor = {
    --     cmd = { "phpactor", "language-server" },
    --     filetypes = { "php" },
    --     root_dir = function(bufnr, on_dir)
    --         local fname = vim.api.nvim_buf_get_name(bufnr)
    --         local cwd = assert(vim.uv.cwd())
    --         local root = vim.fs.root(fname, { "composer.json", ".git", ".phpactor.json", ".phpactor.yml" })
    --
    --         -- prefer cwd if root is a descendant
    --         on_dir(root and vim.fs.relpath(cwd, root) and cwd)
    --     end,
    -- },

    -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/intelephense.lua#L28
    intelephense = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local cwd = assert(vim.uv.cwd())
            local root = vim.fs.root(fname, { "composer.json", ".git" })

            -- prefer cwd if root is a descendant
            on_dir(root and vim.fs.relpath(cwd, root) and cwd)
        end,
    },
}

for name, opts in pairs(servers) do
    vim.lsp.enable(name)
    vim.lsp.config(name, opts)
end
