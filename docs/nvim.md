# Neovim

NvChad v2.5 framework (`init.lua:21`). Theme: `everblush`.

## Key files

| File                        | Purpose                                                |
| --------------------------- | ------------------------------------------------------ |
| `lua/chadrc.lua`            | Theme and UI overrides                                 |
| `lua/mappings.lua`          | Custom keymaps                                         |
| `lua/options.lua`           | Editor settings                                        |
| `lua/configs/lspconfig.lua` | LSP servers: gopls, intelephense, pyright, templ, html |
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

## Maintenance

- DAP PHP requires `:MasonInstall php-debug-adapter`
- Reinstall: `rm -rf ~/.local/share/nvim && nvim`
