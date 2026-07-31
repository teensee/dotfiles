# AGENTS.md

**MANDATORY**: whenever you change any configuration (new/removed file, plugin, package, alias, keybinding), verify that `AGENTS.md` and files in `docs/` are still accurate and update them. Docs must always match the actual repo state.

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

## Adding new configs

1. Create config dir/file under `.dotfiles/`
2. Add symlink entry to `install.conf.yaml`
3. If it requires a Homebrew package, add to `brew/Brewfile`
4. Run `make install`

## Post-install

Copy example git configs (per-host overrides, not tracked):

```
cp git/gitconfig-local.example git/gitconfig-local
cp git/gitconfig-work.example git/gitconfig-work
```

## Architecture

- `install.conf.yaml` — single source of truth for symlinks; `relink: true` means re-running is safe
- Dotbot is a git submodule (`.gitmodules` → `dotbot/`)
- `brew/Brewfile` — Homebrew packages, auto-installed on `make install`
- TPM plugin path is `~/.config/tmux/plugins/`
- `zed/conversations/` and `zed/prompts/` are runtime data (gitignored)

### Per-tool reference

- [docs/nvim.md](docs/nvim.md)
- [docs/zed.md](docs/zed.md)
- [docs/git.md](docs/git.md)
- [docs/shell.md](docs/shell.md)
- [docs/terminal.md](docs/terminal.md)
- [docs/opencode.md](docs/opencode.md)
