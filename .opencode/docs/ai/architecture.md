# Architecture

## Repo layout

- `install.conf.yaml` — single source of truth for symlinks; `relink: true` means re-running is safe
- Dotbot is a git submodule (`.gitmodules` → `dotbot/`)
- `scripts/` — shell scripts called by Makefile; shared helpers in `_lib.sh`;
  `install-omz.sh` bootstraps oh-my-zsh + custom plugins on `make install` / `make update`
- `brew/Brewfile` — Homebrew packages, verified on `make install`/`make update`
- TPM plugin path is `~/.config/tmux/plugins/`
- `opencode/skills/` is the single source for agent skills — dotbot links it to `~/.claude/skills`
  as well (SDD/superpowers pack shared by both tools)
- `zed/conversations/`, `zed/prompts/`, and `zed/themes/*` are runtime data (gitignored; `.gitkeep` preserves the dir)

## Adding new configs

1. Create config dir/file under `.dotfiles/`
2. Add symlink entry to `install.conf.yaml`
3. If it requires a Homebrew package, add to `brew/Brewfile`
4. Run `make install`

## Docs wiring

- AGENTS.md is auto-loaded by opencode's native AGENTS.md convention
- Claude Code doesn't read AGENTS.md natively — `CLAUDE.md` at repo root `@`-imports this file
  instead of duplicating it, so a Claude Code session working in `~/.dotfiles` gets the same context
- Don't confuse it with `claude/CLAUDE.md` (global, user-level, symlinked to `~/.claude/CLAUDE.md` —
  see [claude-code.md](claude-code.md))