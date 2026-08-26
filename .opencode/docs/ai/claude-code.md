# Claude Code config

`claude/` mirrors the opencode config for the Claude Code CLI, symlinked via `install.conf.yaml`
into `~/.claude/`:

- `claude/CLAUDE.md` → `~/.claude/CLAUDE.md` — `@`-imports `shared/instructions-core.md`, plus a
  Claude-specific residual (task workflow, settings/agents/commands pointers) — see
  [instructions.md](instructions.md)
- `claude/settings.json` → `~/.claude/settings.json` — model/statusline/plugin config plus
  `permissions.allow/deny` mirroring `opencode.jsonc`'s git bash permission table
- `claude/agents/` → `~/.claude/agents/` — subagents ported 1:1 from `opencode/agent/` (dba, devops,
  go-dev, symfony-dev, test-writer, architect, code-reviewer, debugger, explore, python-pro,
  research, rust-engineer, security-auditor, zig-dev)
- `claude/commands/` → `~/.claude/commands/` — slash commands ported from `opencode/commands/`
  (task, res, plan, go, review, clean, pg-ro, beautify-agents), using root-level `task.md` /
  `task-research.md` / `task-plan.md` / `task-log.md` (not branch-scoped like opencode's
  `.opencode/work/<branch>/`)
- `claude/skills/` → `~/.claude/skills/` — the "superpowers" skill pack copied verbatim from
  `opencode/skills/` (SKILL.md format is compatible between the two tools)

MCP servers (codegraph, postgres) are registered directly via `claude mcp add`, not through a
tracked config file — see `/pg-ro` for the postgres recipe.

## Known drift risk

Some MCP servers' Claude Code auto-integration (confirmed for `codegraph`) rewrites
`~/.claude/CLAUDE.md` / `~/.claude/settings.json` **as plain files**, silently replacing the dotbot
symlink with a real file. `make check` will flag this as `FILE (not a symlink)` for the affected
`.claude/*` entry (all six are listed in `scripts/_lib.sh`'s `TARGETS`). If it happens: diff the
live file against `.dotfiles/claude/...`, merge the new content into the tracked copy by hand
(codegraph's own additions are marked with `<!-- CODEGRAPH_START/END -->` in `CLAUDE.md`), delete
the live plain file, then re-run `./install` to restore the symlink.