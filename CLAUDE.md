# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS dotfiles for Go/PHP development, managed by [Dotbot](https://github.com/anishathalye/dotbot). All configs are symlinked to their standard locations via `install.conf.yaml`.

## Key Commands

```bash
make install    # Full install (creates backup, then runs dotbot)
make update     # git pull + submodule update + re-run dotbot
make backup     # Snapshot existing configs to ~/.dotfiles-backup-TIMESTAMP
make check      # Report status of managed symlinks (OK / BROKEN / MISS)
make clean      # Clear nvim cache and zcompdump
make clean-tmux # Wipe tmux-resurrect snapshots (separate by design)
```

The `./install` script is the raw dotbot runner; `make install` wraps it with a backup step.

## Architecture

### Symlinking (Dotbot)
`install.conf.yaml` is the single source of truth for what gets linked where. Any new config directory must be registered here before it takes effect. The `relink: true` default means re-running install is safe.

### Neovim (`nvim/`)
Built on **NvChad v2.5** framework (`branch = "v2.5"` in `init.lua`). Structure:
- `lua/chadrc.lua` — theme (`everblush`, toggles with `doomchad`), UI overrides.
- `lua/mappings.lua` — all custom keymaps on top of NvChad defaults.
- `lua/configs/lspconfig.lua` — LSP servers: `gopls`, `intelephense`, `pyright`, `templ`, `html`.
- `lua/configs/conform.lua` — formatters.
- `lua/plugins/` — lazy-loaded plugin specs split by concern:
  - `programming.lua` — go.nvim, phpactor, nvim-dap (PHP/Go), neotest (Go only — adapter `neotest-golang`), nvim-lint (golangci-lint, phpstan)
  - `database.lua` — vim-dadbod + UI
  - `ai-assistants.lua` — copilot (currently disabled)
  - `blink-cmp.lua` — completion engine
  - `ui.lua`, `trouble.lua`, `lazy-git.lua`, etc.

To sync plugins: `:Lazy sync`. To reinstall from scratch: `rm -rf ~/.local/share/nvim && nvim`.

### Git (`git/`)
- `gitconfig` — global config with identity (`vlad / stimulmonk@yandex.ru`) and `stats` alias.
- Conditional includes: `gitconfig-etp` activates for `~/PhpstormProjects/projects/etp/` and `~/Programming/Go/elk_hub/` (symlinked to `~/.gitconfig-etp` via `install.conf.yaml`).
- `gitconfig-local` and `gitconfig-work` are **not tracked** (see `.gitignore`) — copy from `git/gitconfig-{local,work}.example`, then symlink to `~/.gitconfig-{local,work}` manually. They are loaded unconditionally via `[include]` in `gitconfig`; missing files are silently ignored by git.

### Shell (`zsh/`)
Oh-My-Zsh with `bureau` theme. Key additions: `fzf` keybindings, `thefuck` alias, asdf shims, `mux` → tmuxinator shortcut, `nvnotes` → opens Obsidian vault in Neovim.

### Tmux (`tmux/tmux.conf`)
Prefix is default `Ctrl-B`. Custom bindings:
- `|` / `-` — split horizontal/vertical in current path
- `h/j/k/l` — vim-style pane navigation
- `r` — reload config
- `Tab` — last window
- Dracula theme with battery, CPU, RAM, time in status bar (top).

### Tool Versions (`asdf/tool-versions`)
Runtime versions managed by asdf. Edit this file to change global language versions.

### Homebrew (`brew/Brewfile`)
Run `brew bundle --file=~/Brewfile` to install all packages. Key tools: go, php, composer, node, python, postgresql@14, neovim, tmux, lazygit, lazydocker, fzf, ripgrep, k6, ollama.

## Adding New Configurations

1. Create config directory/file under `.dotfiles/`
2. Add symlink entry to `install.conf.yaml`
3. Run `make install` to apply
4. If it's a Homebrew package, add to `brew/Brewfile`
