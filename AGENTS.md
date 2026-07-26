# AGENTS.md

Personal macOS dotfiles for Go/PHP development, managed by [Dotbot](https://github.com/anishathalye/dotbot).

## Commands

```
make install      # backup + dotbot install
make update       # git pull + submodule update + re-run dotbot
make backup       # snapshot configs to ~/.dotfiles-backup-TIMESTAMP
make check        # check symlink status
make clean        # nvim cache + zcompdump
make clean-tmux   # wipe tmux-resurrect snapshots
make restore      # restore from latest backup
make help         # show all available commands
```

`./install` is the raw dotbot runner; `make install` wraps it with a backup step.

## Architecture

### Symlinking (`install.conf.yaml`)
Single source of truth for what gets linked. Add any new config dir here first. `relink: true` means re-running install is safe.

### Neovim (`nvim/`)
NvChad v2.5 framework. Theme is `everblush` (toggle with `doomchad`).
- `lua/chadrc.lua` — theme, UI overrides
- `lua/mappings.lua` — all custom keymaps
- `lua/configs/lspconfig.lua` — LSP: gopls, intelephense, pyright, templ, html
- `lua/configs/conform.lua` — formatters
- `lua/plugins/` — lazy-loaded plugin specs:
  - `programming.lua` — go.nvim, phpactor, nvim-dap (PHP/Go), neotest (Go only via `neotest-golang`), nvim-lint (golangci-lint, phpstan)
  - `database.lua` — vim-dadbod + UI
  - `ai-assistants.lua` — copilot (disabled) — re-enable: rm `enabled = false` + uncomment in blink-cmp.lua
  - `blink-cmp.lua` — completion engine (includes dadbod per_filetype)
  - `trouble.lua`, `nvim-tree.lua`, `nvim-treesitter.lua`, `telescope.lua`, `obsidian-plugin.lua`, `trainings.lua`
- NvChad v2.5 includes `mason.nvim` — DAP PHP requires `:MasonInstall php-debug-adapter`
- Reinstall: `rm -rf ~/.local/share/nvim && nvim`

### Git (`git/`)
- `gitconfig` — identity (vlad / stimulmonk@yandex.ru) + `stats` alias
- `gitconfig-local` and `gitconfig-work` are **not tracked** — copy from `.example` files:
  ```
  cp git/gitconfig-local.example git/gitconfig-local
  cp git/gitconfig-work.example git/gitconfig-work
  ```
- `gitconfig-etp` — conditional include for `~/PhpstormProjects/projects/etp/` and `~/Programming/Go/elk_hub/`
- `gitignore_global` — macOS (.DS_Store) + Claude Code (.claude) patterns

### Shell (`zsh/`)
Oh-My-Zsh + bureau theme. Key aliases: `mux` (tmuxinator), `nvnotes` (Obsidian in Neovim). asdf shims sourced in `.zshrc`.

### Tmux (`tmux/tmux.conf`)
Prefix: `Ctrl-B`. Custom: `|`/`-` splits, `h/j/k/l` pane nav, `r` reload, `Tab` last window. Dracula theme. TPM installed by `install.conf.yaml`. Install plugins: `Prefix + I`.

### Ghostty (`ghostty/config`)
GPU-accelerated terminal emulator. Font, theme, and macOS window settings.

### Fish shell (`fish/`)
Alternative shell with built-in autosuggestions: `config.fish`, custom completions (`completions/`), config snippets (`conf.d/`), custom functions (`functions/`).

### LazyGit (`lazygit/`)
Terminal UI for Git operations. Custom theme and keyboard shortcuts.

### htop (`htop/htoprc`)
System resource monitor. Custom display and color configuration.

### IdeaVim (`vim/ideavimrc`)
Vim emulation for JetBrains IDEs. Custom key mappings.

### Tmuxinator (`tmuxinator/`)
Project-specific tmux session templates. `mux <project>` shortcut via zsh alias.

### OpenCode (`opencode/`)
AI coding agent configuration for OpenCode CLI.
- `opencode.jsonc` — model (`deepseek-v4-pro`), LSP enabled, [superpowers](https://github.com/obra/superpowers) plugin, permission rules (git destructive commands denied)
- `agent/` — custom subagents: `dba`, `devops`, `go-dev`, `research`, `symfony-dev`, `test-writer`
- `commands/` — custom slash commands: `clean`, `go`, `plan`, `res`
- `plugin/` — reserved for local plugins
- Dependencies: `package.json` + `node_modules` (ignored, not tracked)

### Homebrew (`brew/Brewfile`)
`brew bundle --file=~/Brewfile` (runs automatically on install). Key: go, php, node, python, postgresql@14, neovim, tmux, lazygit, lazydocker, fzf, ripgrep, k6, ollama.

## Adding new configs

1. Create config dir/file under `.dotfiles/`
2. Add symlink entry to `install.conf.yaml`
3. Run `make install` to apply
4. If Homebrew package, add to `brew/Brewfile`

## Notes

- Dotbot is a git submodule (`.gitmodules` → `dotbot/`)
- `readme.md` — brief overview for humans; this file (`AGENTS.md`) is the tracked instruction file for agents
- TPM plugin path is `~/.config/tmux/plugins/` (set via `TMUX_PLUGIN_MANAGER_PATH` in `tmux.conf`)
