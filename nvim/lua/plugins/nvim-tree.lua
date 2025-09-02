return {
    "nvim-tree/nvim-tree.lua",
    opts = {
        filters = {
            dotfiles = false,
            custom = {
                "^.git$",
                "^.idea$",
                "^.obsidian$",
                "^.DS_Store$",
            },
        },
        renderer = {
            group_empty = false,
        },
        git = {
            ignore = false,
        },
        view = {
            width = 50,
        },

        -- Отключить автоматическое выделение текущего файла
        update_focused_file = {
            enable = false, -- изменить на false чтобы отключить
        },
    },
}
