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
        cmd = { "VimBeGood" },
    },
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        enabled = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            disable_mouse = false,
        },
    },
}
