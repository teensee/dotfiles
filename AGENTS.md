# AGENTS.md

Personal macOS dotfiles for Go/PHP development, managed by
[Dotbot](https://github.com/anishathalye/dotbot).

**MANDATORY**: whenever you change any configuration (new/removed file, plugin, package, alias,
keybinding), verify that `AGENTS.md`, the topic files in `.opencode/docs/ai/`, and files in `docs/`
are still accurate and update them. Docs must always match the actual repo state.

## Commands

```sh
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

## Hard rules

- **Git — read-only**: the agent works with git **exclusively read-only** — see
  `shared/instructions-core.md` for the full allow/deny list. Enforced in
  `opencode/opencode.jsonc`'s `permission.bash` table and in `claude/settings.json`'s
  `permissions.deny`. All git write operations are performed by the user.

## Commit messages

Applies to this repository only. The agent never commits (see Hard rules) — it proposes the message
and the command; the user runs them. Messages follow Conventional Commits, in English:
`type(scope): summary`.

- Types: `feat`, `fix`, `refactor`, `perf`, `style`, `docs`, `chore` (+ `test`, `build`, `ci`,
  `revert` when needed)
- Pick the type by effect, not diff size:
  - new behavior/feature → `feat`; fixing wrong behavior → `fix`
  - restructuring/cleanup without behavior change → `refactor` (deletions count here)
  - deps, versions, tooling config, routine → `chore`; docs only → `docs`; formatting only →
    `style`; speed → `perf`
- `scope` is the tool/dir in lowercase (`zsh`, `zed`, `nvim`, `opencode`, `claude`, `brew`, `docs`);
  multiple scopes are allowed comma-separated: `refactor(claude,opencode): ...`
- Summary: imperative, lowercase, no trailing period, ≤ 72 chars. Body: `-` bullets, wrapped ~100
- Pre-convention commits are not rewritten; new messages always follow this convention

## Topic files

- [`.opencode/docs/ai/architecture.md`](.opencode/docs/ai/architecture.md) — read this when the repo
  layout or dotbot wiring matters (symlinks, submodule, scripts, brew)
- [`.opencode/docs/ai/tools.md`](.opencode/docs/ai/tools.md) — read this before reaching for a
  standard Unix tool (`ls`, `find`, `cd`, `git diff`, `du`, `df`, `man`) or hand-parsing JSON/YAML
  (`jq` / `yq`)
- [`.opencode/docs/ai/workflow.md`](.opencode/docs/ai/workflow.md) — read this when implementing a
  task via the opencode pipeline or looking up per-tool docs
- [`.opencode/docs/ai/git.md`](.opencode/docs/ai/git.md) — read this when setting up or modifying
  per-host git configs
- [`.opencode/docs/ai/instructions.md`](.opencode/docs/ai/instructions.md) — read this when editing
  agent/command/instruction config shared between opencode and Claude Code
- [`.opencode/docs/ai/claude-code.md`](.opencode/docs/ai/claude-code.md) — read this when
  maintaining the Claude Code config (mirror, symlinks, MCP, drift risk)
