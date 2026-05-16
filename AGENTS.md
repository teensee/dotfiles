# AGENTS.md

Personal macOS dotfiles for Go/PHP development, managed by [Dotbot](https://github.com/anishathalye/dotbot).

## Commands

```
make install    # backup + dotbot install
make update     # git pull + submodule update + re-run dotbot
make backup     # snapshot configs to ~/.dotfiles-backup-TIMESTAMP
make check      # check symlink status
make clean      # nvim cache + tmux resurrect + zcompdump
```

`./install` is the raw dotbot runner; `make install` wraps it with a backup step.

## Architecture

### Symlinking (`install.conf.yaml`)
Single source of truth for what gets linked. Add any new config dir here first. `relink: true` means re-running install is safe.

### Neovim (`nvim/`)
NvChad v3 framework. Theme is `everblush` (toggle with `doomchad`).
- `lua/chadrc.lua` — theme, UI overrides
- `lua/mappings.lua` — all custom keymaps
- `lua/configs/lspconfig.lua` — LSP: gopls, intelephense, pyright, templ, html
- `lua/configs/conform.lua` — formatters
- `lua/plugins/` — lazy-loaded plugin specs:
  - `programming.lua` — go.nvim, phpactor, nvim-dap (PHP/Go), neotest (Go/PHPUnit), nvim-lint
  - `database.lua` — vim-dadbod + UI
  - `ai-assistants.lua` — copilot (disabled) — re-enable: rm `enabled = false` + uncomment in blink-cmp.lua
  - `blink-cmp.lua` — completion engine (includes dadbod per_filetype)
- Reinstall: `rm -rf ~/.local/share/nvim && nvim`

### Git (`git/`)
- `gitconfig` — identity (vlad / stimulmonk@yandex.ru)
- `gitconfig-local` and `gitconfig-work` are **not tracked** — copy from `.example` files:
  ```
  cp git/gitconfig-local.example git/gitconfig-local
  cp git/gitconfig-work.example git/gitconfig-work
  ```
- Conditional include for etp/elk_hub paths via `gitconfig-etp`

### Shell (`zsh/`)
Oh-My-Zsh + bureau theme. Key aliases: `mux` (tmuxinator), `nvnotes` (Obsidian in Neovim). asdf shims sourced in `.zshrc`.

### Tmux (`tmux/tmux.conf`)
Prefix: `Ctrl-B`. Custom: `|`/`-` splits, `h/j/k/l` pane nav, `r` reload, `Tab` last window. TPM installed by `install.conf.yaml`. Install plugins: `Prefix + I`.

### Tool versions (`asdf/tool-versions`)
Edit this file to change global runtime versions.

### Homebrew (`brew/Brewfile`)
`brew bundle --file=~/Brewfile` (runs automatically on install). Key: go, php, node, python, postgresql@14, neovim, tmux, lazygit, lazydocker, fzf, ripgrep, k6, ollama.

## Adding new configs

1. Create config dir/file under `.dotfiles/`
2. Add symlink entry to `install.conf.yaml`
3. Run `make install` to apply
4. If Homebrew package, add to `brew/Brewfile`

## Notes

- Dotbot is a git submodule (`.gitmodules` → `dotbot/`)
- `CLAUDE.md` is gitignored — this file (`AGENTS.md`) is the tracked instruction file
- `readme.md` / `documentation.md` exist but may be stale; prefer `install.conf.yaml` and Makefile as executable truth
- `upgrade.md` documents unmerged feature-branch changes (dap, neotest, nvim-lint) still pending merge review
