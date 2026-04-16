return {
    -- golang
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup {
                tag_transform = "camelcase",
                lsp_gofumpt = true,
            }
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
    },

    -- php (phpactor как инструмент рефакторинга, LSP — intelephense)
    {
        "phpactor/phpactor",
        enabled = true,
        ft = "php",
        build = "composer install --optimize-autoloader",
        cmd = { "Phpactor" },
    },

    -- snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- debug adapter protocol
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>dc", desc = "Debug: Continue" },
            { "<leader>do", desc = "Debug: Step over" },
            { "<leader>di", desc = "Debug: Step into" },
            { "<leader>dO", desc = "Debug: Step out" },
            { "<leader>bp", desc = "Toggle breakpoint" },
            { "<leader>du", desc = "Toggle debug UI" },
        },
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                config = function()
                    require("dapui").setup()
                end,
            },
        },
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"

            -- автоматически открывать/закрывать UI при старте/остановке отладки
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- PHP (Xdebug)
            dap.adapters.php = {
                type = "executable",
                command = "node",
                args = { vim.fn.stdpath "data" .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
            }
            dap.configurations.php = {
                {
                    type = "php",
                    request = "launch",
                    name = "Listen for Xdebug",
                    port = 9003,
                    pathMappings = {
                        ["/var/www/html"] = "${workspaceFolder}",
                    },
                },
            }
        end,
    },

    -- Go debugger (Delve)
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("dap-go").setup()
        end,
    },

    -- test runner
    {
        "nvim-neotest/neotest",
        keys = {
            { "<leader>tt", desc = "Run nearest test" },
            { "<leader>tF", desc = "Run file tests" },
            { "<leader>ts", desc = "Toggle test summary" },
            { "<leader>to", desc = "Show test output" },
        },
        cmd = { "Neotest" },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "fredrikaverpil/neotest-golang",
        },
        config = function()
            require("neotest").setup {
                adapters = {
                    require "neotest-golang",
                },
            }
        end,
    },

    -- golangci-lint
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require "lint"
            lint.linters_by_ft = {
                go = { "golangcilint" },
                php = { "phpstan" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
