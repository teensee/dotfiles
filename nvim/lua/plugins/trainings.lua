return {
    {
        "nvzone/typr",
        event = "VeryLazy",
        dependencies = "nvzone/volt",
        opts = {},
        cmd = { "Typr", "TyprStats" },
    },
    {
        "ThePrimeagen/vim-be-good",
        event = "VeryLazy",
    },
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        enabled = true,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            disable_mouse = false,
        },
    },
}
