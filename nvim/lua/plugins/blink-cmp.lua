return {
    { import = "nvchad.blink.lazyspec" },
    {
        "saghen/blink.cmp",
        enabled = true,
        event = { "LspAttach", "InsertEnter" },
        opts = {
            sources = {
                -- sut copitol suggestion on top
                default = { "copilot", "lsp", "path", "snippets", "buffer" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
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
    {
        "giuxtaposition/blink-cmp-copilot",
        after = { "copilot.lua" },
    },
}
