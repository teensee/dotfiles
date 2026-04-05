require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>ch", ":NvCheatsheet<CR>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Obsidian
map("n", "<leader>od", ":Obsidian dailies<CR>", { desc = "Ежедневные заметки" })

-- NvimTree
map("n", "<leader>tf", ":NvimTreeFindFile<CR>", { desc = "Find file in tree" })

-- Telescope File Browser
map("n", "<leader>fd", "<cmd>Telescope file_browser<CR>", { desc = "File browser" })
-- маппинг под вопросиком
map(
    "n",
    "<leader>fD",
    "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { desc = "File browser (current dir)" }
)

-- LazyGit
map("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "Toggle LazyGit" })

-- Git операции через Gitsigns
map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
map("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
map("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Blame line" })

-- which-key group descriptions
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
    wk.add {
        { "<leader>d", group = "Debug/Database" },
        { "<leader>g", group = "Git" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>t", group = "Test/Tree" },
        { "<leader>o", group = "Obsidian" },
    }
end

-- dadbod
map("n", "<leader>db", ":DBUIToggle<CR>", { desc = "Toggle Database UI" })
map("n", "<leader>dq", ":DB<CR>", { desc = "Execute DB query" })
map("v", "<leader>dq", ":'<,'>DB<CR>", { desc = "Execute selected query" })

-- LSP
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code action" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })

-- Diagnostics (Trouble)
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list (Trouble)" })

-- Debug (DAP)
map("n", "<leader>dc", function()
    require("dap").continue()
end, { desc = "Debug: Continue" })
map("n", "<leader>do", function()
    require("dap").step_over()
end, { desc = "Debug: Step over" })
map("n", "<leader>di", function()
    require("dap").step_into()
end, { desc = "Debug: Step into" })
map("n", "<leader>dO", function()
    require("dap").step_out()
end, { desc = "Debug: Step out" })
map("n", "<leader>bp", function()
    require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
map("n", "<leader>du", function()
    require("dapui").toggle()
end, { desc = "Toggle debug UI" })

-- Neotest
map("n", "<leader>tt", function()
    require("neotest").run.run()
end, { desc = "Run nearest test" })
map("n", "<leader>tF", function()
    require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run file tests" })
map("n", "<leader>ts", function()
    require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
map("n", "<leader>to", function()
    require("neotest").output.open { enter_on_open = true }
end, { desc = "Show test output" })
