return {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
        cmdline = { enabled = true },
        -- Тестово выключил часть ЮИ-изменений для сохранения ""аутентичности"
        messages = { enabled = false },
        popupmenu = { enabled = false },
        notify = { enabled = false },

        lsp = {
            progress = {
                enabled = true,
                format = "lsp_progress",
                format_done = "lsp_progress_done",
                throttle = 1000 / 30,
                view = "mini",
            },
            hover = { enabled = true },
            message = { enabled = true },
            documentation = { enabled = true },
            signature = {
                enabled = true,
                auto_open = { enabled = true, trigger = true },
            },
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}
