-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {
    base46 = {
        -- theme = "onedark",
        theme = "everblush",
        theme_toggle = { "everblush", "catppuccin" },
    },
    ui = {
        cmp = {
            icons_left = false,
            style = "default",
        },
        tabufline = {
            lazyload = false,
        },
        telescope = { style = "bordered" },
        statusline = {
            theme = "default",
            separator_style = "block",
        },
    },
    nvdash = {
        load_on_startup = true,
    },
}

return M
