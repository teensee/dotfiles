return {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
        cmdline = { enabled = true },
        messages = { enabled = true },
        popupmenu = { enabled = true },
        notify = { enabled = true },

        lsp = {
            progress = {
                enabled = true, -- прогресс LSP можно оставить
                format = "lsp_progress",
                format_done = "lsp_progress_done",
                throttle = 1000 / 30,
                view = "mini",
            },
            hover = { enabled = true },
            message = { enabled = true },
            documentation = { enabled = true },
            signature = { enabled = false }, -- if "true" jumping cursor bugs here...
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
}
