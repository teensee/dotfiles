require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>ch", ":NvCheatsheet<CR>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Obsidian
map("n", "<leader>od", ":ObsidianDailies<CR>", { desc = "Ежедневные заметки" })
map("n", "<leader>ck", ":ObsidianToggleCheckbox<CR>", { desc = "Toggle checkbox" })

-- LazyGit
map("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "Toggle LazyGit" })

-- Git операции через Gitsigns
map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
map("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
map("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Blame line" })

-- dadbot
map("n", "<leader>db", ":DBUIToggle<CR>", { desc = "Toggle Database UI" })
map("n", "<leader>dq", ":DB<CR>", { desc = "Execute DB query" })
map("v", "<leader>dq", ":'<,'>DB<CR>", { desc = "Execute selected query" })
