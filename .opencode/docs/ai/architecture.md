# Architecture

- `install.conf.yaml` — single source of truth for symlinks; `relink: true` means re-running is safe
- Dotbot is a git submodule (`.gitmodules` → `dotbot/`)
- `scripts/` — shell scripts called by Makefile; shared helpers in `_lib.sh`
- `brew/Brewfile` — Homebrew packages, verified on `make install`/`make update`
- TPM plugin path is `~/.config/tmux/plugins/`
- `zed/conversations/`, `zed/prompts/`, and `zed/themes/*` are runtime data (gitignored; `.gitkeep` preserves the dir)
