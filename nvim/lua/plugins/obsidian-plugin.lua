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
        -- completion идёт через встроенный obsidian-ls LSP (источник "lsp" в blink.cmp),
        -- отдельные флаги nvim_cmp/blink удалены в 3.x и убираются в 4.0
        completion = {
            min_chars = 2,
        },
        -- старые команды (:ObsidianBacklinks) отключены, используем :Obsidian <subcommand>
        legacy_commands = false,
        daily_notes = {
            folder = "Daily", -- Папка для ежедневных заметок
            date_format = "%Y-%m-%d", -- Формат даты для удобства
        },
    },
}
