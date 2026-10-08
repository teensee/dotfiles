# Neovim

NvChad v2.5 framework (`init.lua:21`). Theme: `everblush`.

## Key files

| File                        | Purpose                                                |
| --------------------------- | ------------------------------------------------------ |
| `lua/chadrc.lua`            | Theme and UI overrides                                 |
| `lua/mappings.lua`          | Custom keymaps (incl. `<leader>cl` run code lens, `<leader>ch` toggle inlay hints) |
| `lua/options.lua`           | Editor settings                                        |
| `lua/configs/lspconfig.lua` | LSP servers: gopls, phpantom_lsp, basedpyright (auto-detects project `.venv`, e.g. from uv), ruff, templ, html. phpantom_lsp takes no settings here — `cmd`/`filetypes`/`root_markers` come from nvim-lspconfig and the server is configured in `phpantom/.phpantom.toml` (shared with Zed, which runs the same server). PHP extras enabled for phpantom buffers only: code lens and inlay hints (`LspAttach`), plus semantic tokens kept alive by overriding NvChad's `on_init`, which strips `semanticTokensProvider` from every server. phpantom's lenses use the VS Code-style client command `editor.action.showReferences`, implemented here via `vim.lsp.commands` → quickfix → Trouble |
| `lua/configs/conform.lua`   | Formatters (sourced by `lua/plugins/conform.lua`)      |

## Plugins (`lua/plugins/`)

| File                 | Contains                                                                                                    |
| -------------------- | ----------------------------------------------------------------------------------------------------------- |
| `programming.lua`    | go.nvim, phpactor, nvim-dap (PHP/Go), neotest (Go via `neotest-golang`), nvim-lint (golangci-lint, phpstan) |
| `database.lua`       | vim-dadbod + UI                                                                                             |
| `ai-assistants.lua`  | copilot (disabled; re-enable: rm `enabled = false` + uncomment in blink-cmp.lua)                            |
| `blink-cmp.lua`      | Completion engine (includes dadbod per_filetype)                                                            |
| `conform.lua`        | Plugin spec — delegates to `configs.conform`                                                                |
| `nvim-lspconfig.lua` | Plugin spec — delegates to `configs.lspconfig`                                                              |

Other plugins: `trouble.lua`, `nvim-tree.lua`, `nvim-treesitter.lua`, `telescope.lua`, `obsidian-plugin.lua`, `trainings.lua`, `lazy-git.lua`.

## Scripts

- `lua/scripts/go-constructor.lua` — Go constructor generator for structs
- `lua/scripts/scratch.lua` — `:Scratch [ext]` creates scratch files in `~/Programming/scratches`, sharing the directory and templates (`zed/tasks/scratch/_templates/`) with the Zed scratch tasks; `go` gets an isolated module `go/scratch_N/`

## Maintenance

- PHP LSP requires `:MasonInstall phpantom_lsp`
- DAP PHP requires `:MasonInstall php-debug-adapter`
- Reinstall: `rm -rf ~/.local/share/nvim && nvim`
