# Claude Code config

`claude/` holds the Claude Code CLI config (mirroring opencode where possible), symlinked via
`install.conf.yaml` into `~/.claude/`:

- `claude/CLAUDE.md` → `~/.claude/CLAUDE.md` — `@`-imports `shared/instructions-core.md`, plus a
  Claude-specific residual (task workflow, settings/agents/commands pointers) — see
  [instructions.md](instructions.md)
- `claude/settings.json` → `~/.claude/settings.json` — model/statusline/plugin config plus
  `permissions.allow/deny` mirroring `opencode.jsonc`'s git bash permission table
- `claude/agents/` → `~/.claude/agents/` — subagents, hand-mirrored from `opencode/agent/` (dba,
  devops, go-dev, symfony-dev, test-writer, architect, code-reviewer, debugger, explore, python-pro,
  research, rust-engineer, security-auditor, zig-dev). The mirror has **not** been maintained: all
  14 have drifted from their opencode counterparts (Claude copies frozen at `eaaa193`); unification
  in EN is a separate task
- `claude/commands/` → `~/.claude/commands/` — slash commands, likewise frozen at `eaaa193` and
  drifted: opencode's `/review-task` is `/review` here, and `/yt-comm` exists only in opencode. Uses
  root-level `task.md` / `task-research.md` / `task-plan.md` / `task-log.md` (not branch-scoped like
  opencode's `.opencode/work/<branch>/`)
- `claude/skills/` — не существует как отдельный набор: dotbot линкует `~/.claude/skills` прямо на
  `opencode/skills/` (единый источник для обоих тулзов, SKILL.md-формат совместим)

MCP servers (codegraph, postgres) are registered directly via `claude mcp add`, not through a
tracked config file — see `/pg-ro` for the postgres recipe.

## Known drift risk

Two triggers rewrite `~/.claude/CLAUDE.md` / `~/.claude/settings.json` **as plain files**, silently
replacing the dotbot symlink with a real file:

- some MCP servers' Claude Code auto-integration (confirmed for `codegraph`)
- the Claude UI itself, when plugins/marketplaces are enabled or changed (confirmed 24.09.2026:
  `settings.json` came back tab-indented with `600` permissions, carrying
  `gitkraken-hooks@gitkraken` + `extraKnownMarketplaces` that existed only in the live file)

`make check` will flag this as `FILE (not a symlink)` for the affected `.claude/*` entry (all six
are listed in `scripts/_lib.sh`'s `TARGETS`). If it happens: diff the live file against
`.dotfiles/claude/...`, merge the new content into the tracked copy by hand (the CodeGraph block
itself lives in `shared/instructions-core.md` — if codegraph re-injects a copy into `CLAUDE.md`,
delete the copy), delete the live plain file, then re-run `./install` to restore the symlink.
