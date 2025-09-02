return {
    {
        "tpope/vim-dadbod",
        lazy = true,
        cmd = { "DB" },
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Настройки vim-dadbod-ui
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_winwidth = 50
            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.g.db_ui_save_location = vim.fn.stdpath "data" .. "/db_ui"
            -- Показывать схемы таблиц
            vim.g.db_ui_show_database_icon = 1
            vim.g.db_ui_use_nvim_notify = 1
            -- Автодополнение
            vim.g.db_ui_disable_mappings = 0
        end,
        config = function()
            -- Автодополнение для SQL файлов
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function()
                    require("cmp").setup.buffer {
                        sources = {
                            { name = "vim-dadbod-completion" },
                            { name = "buffer" },
                        },
                    }
                end,
            })
        end,
    },
}
