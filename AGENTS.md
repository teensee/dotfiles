# AGENTS.md

**MANDATORY**: whenever you change any configuration (new/removed file, plugin, package, alias, keybinding), verify that `AGENTS.md` and files in `docs/` are still accurate and update them. Docs must always match the actual repo state.

Personal macOS dotfiles for Go/PHP development, managed by [Dotbot](https://github.com/anishathalye/dotbot).

## Commands

```
make install      # backup + dotbot install + brew check
make update       # backup + git pull + submodule update + dotbot install + brew check
make backup       # snapshot configs to ~/.dotfiles-backup-TIMESTAMP
make check        # check symlink status
make clean        # nvim cache + zcompdump
make clean-tmux   # wipe tmux-resurrect snapshots
make restore      # restore from latest backup (interactive confirmation)
make help         # show all available commands
```

`./install` is the raw dotbot runner; `make install` wraps it with a backup step and brew check.

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
- `scripts/` — shell scripts called by Makefile; shared helpers in `_lib.sh`
- `brew/Brewfile` — Homebrew packages, verified on `make install`/`make update`
- TPM plugin path is `~/.config/tmux/plugins/`
- `zed/conversations/`, `zed/prompts/`, and `zed/themes/*` are runtime data (gitignored; `.gitkeep` preserves the dir)

## CLI Tools

Modern replacements for standard Unix tools. All support `--help` for usage.

| Instead of | Use                        | Notes                                                             |
| ---------- | -------------------------- | ----------------------------------------------------------------- |
| `ls`       | `eza` / `ll` / `la` / `lt` | Drop-in compatible. Extras: `--tree`, `--git`, icons              |
| `find`     | `fd`                       | Different syntax: `fd PATTERN` (regex), `fd -e go` (by extension) |
| `cd`       | `z DIR` (zoxide)           | Frecency-based jumping; regular `cd` still works                  |
| `git diff` | `delta`                    | Transparent — auto via gitconfig                                  |
| `du`       | `dust`                     | `dust` (sorted tree), `dust -d 1` (one level)                     |
| `df`       | `duf`                      | Pretty table, no args needed                                      |
| `man`      | `tldr`                     | `tldr COMMAND` — usage examples, not full docs                    |

### OpenCode workflow

`/res → /plan → /go → /review → /clean` — human-in-the-loop pipeline for task implementation:

1. **`/res`** (research-agent) — reads `task.md`, analyzes codebase, creates `task-research.md`
2. **`/plan`** (architect-agent) — reads research, studies patterns, creates `task-plan.md` (signatures, SQL, config — no implementation)
3. **`/go`** (build-agent) — dispatches plan steps to specialized subagents (go-dev, symfony-dev, etc.), creates `task-log.md`
4. **`/review`** (code-reviewer agent) — reviews `git diff` against plan, outputs findings
5. **`/clean`** (build-agent) — removes `task-*.md` files

### Per-tool reference

- [docs/nvim.md](docs/nvim.md)
- [docs/zed.md](docs/zed.md)
- [docs/git.md](docs/git.md)
- [docs/shell.md](docs/shell.md)
- [docs/terminal.md](docs/terminal.md)
- [docs/opencode.md](docs/opencode.md)
