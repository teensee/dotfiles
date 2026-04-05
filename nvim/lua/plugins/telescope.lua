return {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup {
            extensions = {
                file_browser = {
                    hijack_netrw = true,
                    hidden = { file_browser = true, folder_browser = true },
                    grouped = true,
                    sorting_strategy = "ascending",
                    layout_config = { height = 0.9, width = 0.9 },
                },
            },
        }
        require("telescope").load_extension "file_browser"
    end,
}
