return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require "nvim-treesitter"
        ts.setup()

        local parsers = {
            "vim",
            "lua",
            "vimdoc",
            -- Web
            "html",
            "css",
            "twig",
            -- Main languages
            "php",
            "phpdoc",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "python",
            "sql",
            -- Config languages
            "yaml",
            "markdown",
            "bash",
            "toml",
            "json",
            "http",
            "dockerfile",
        }

        ts.install(parsers)

        -- Аналог auto_install — ставим парсер при открытии файла
        -- Паттерны для автокоманды (filetype != parser name в некоторых случаях)
        local ft_patterns = {
            "vim",
            "lua",
            "help",
            "html",
            "css",
            "twig",
            "php",
            "go",
            "gomod",
            "gosum",
            "gowork",
            "python",
            "sql",
            "yaml",
            "markdown",
            "bash",
            "toml",
            "json",
            "http",
            "dockerfile",
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = ft_patterns,
            callback = function(args)
                -- Включение подсветки (аналог highlight.enable = true)
                vim.treesitter.start(args.buf)
                -- Включение отступов (аналог indent.enable = true)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
