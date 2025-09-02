return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "ObsidianNotes",
                path = vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianNotes",
            },
        },
        completion = {
            nvim_cmp = false,
            blink = true,
            min_chars = 2,
        },
        daily_notes = {
            folder = "Daily", -- Папка для ежедневных заметок
            date_format = "%Y-%m-%d", -- Формат даты для удобства
        },
    },
}
