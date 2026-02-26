return {
    { import = "nvchad.blink.lazyspec" },
    {
        "saghen/blink.cmp",
        enabled = true,
        event = { "LspAttach", "InsertEnter" },
        opts = {
            sources = {
                default = {
                    -- "copilot",
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
                per_filetype = {
                    sql = { "dadbod", "snippets", "buffer" },
                    mysql = { "dadbod", "snippets", "buffer" },
                    plsql = { "dadbod", "snippets", "buffer" },
                },
                providers = {
                    -- copilot = {
                    --     name = "copilot",
                    --     module = "blink-cmp-copilot",
                    --     score_offset = 100,
                    --     async = true,
                    -- },
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                },
            },
            completion = {
                documentation = {
                    auto_show = false, -- отключить автоматическое отображение документации
                },
            },
        },
    },
    -- copilot inside blink cmp completions
    -- {
    --     "giuxtaposition/blink-cmp-copilot",
    --     after = { "copilot.lua" },
    -- },
}
