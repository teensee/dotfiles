return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        enabled = true,
        config = function()
            require("copilot").setup {
                suggestion = { enabled = false },
            }
        end,
    },
}
