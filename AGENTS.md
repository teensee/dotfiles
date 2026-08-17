# AGENTS.md

Personal macOS dotfiles for Go/PHP development, managed by
[Dotbot](https://github.com/anishathalye/dotbot).

**MANDATORY**: whenever you change any configuration (new/removed file, plugin, package, alias,
keybinding), verify that `AGENTS.md`, the topic files in `.opencode/docs/ai/`, and files in `docs/`
are still accurate and update them. Docs must always match the actual repo state.

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

## Topic files

- [`.opencode/docs/ai/architecture.md`](.opencode/docs/ai/architecture.md) — read this when the repo
  layout or dotbot wiring matters (symlinks, submodule, scripts, brew)
- [`.opencode/docs/ai/tools.md`](.opencode/docs/ai/tools.md) — read this before reaching for a
  standard Unix tool (`ls`, `find`, `cd`, `git diff`, `du`, `df`, `man`)
- [`.opencode/docs/ai/workflow.md`](.opencode/docs/ai/workflow.md) — read this when implementing a
  task via the opencode pipeline or looking up per-tool docs
- [`.opencode/docs/ai/git.md`](.opencode/docs/ai/git.md) — read this when setting up or modifying
  per-host git configs

## Git — read-only

The agent works with git **exclusively read-only**
(`git status/diff/log/show/branch -l/remote/rev-parse/...` allowed;
`git add/commit/push/pull/fetch/checkout/switch/merge/rebase/reset/restore/...` denied in
`opencode/opencode.jsonc` and in `opencode/instructions.md`). All git write operations are performed
by the user.

## Task workflow

Task files live in the gitignored `.opencode/work/<current-branch>/` directory of the current repo
(not in the working tree). Use the pipeline:
`/task → /res → /plan → /go → /review → /clean`. See
[`.opencode/docs/ai/workflow.md`](.opencode/docs/ai/workflow.md) for details.
