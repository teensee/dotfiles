return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {
            "vim",
            "lua",
            "vimdoc",

            -- Web
            "html",
            "css",

            -- Main languages
            "php",
            "phpdoc",

            "go",
            "gomod",
            "gosum",
            "gowork",

            "python",

            -- Config languages
            "yaml",
            "markdown",
            "bash",
            "toml",
            "json",
            "http",
            "dockerfile",
        },
        auto_install = true, -- Автоматически устанавливать недостающие парсеры
        sync_install = false, -- Синхронизация парсеров вручную, чтобы избежать подвисаний
        highlight = {
            enable = true, -- Включение подсветки кода
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true, -- Улучшенная автоматическая табуляция
        },
    },
}
