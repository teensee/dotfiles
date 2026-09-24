# Shared instructions (opencode ↔ Claude Code)

`shared/instructions-core.md` is the single source of truth for the rules that are identical in
both tools: read-only git policy, the codegraph → Grep/Glob → `rg`/`fd` → `grep`/`find`
tool-priority ladder, `jq`/`yq` for JSON/YAML (never hand-parse), conditional Postgres MCP usage,
and style (respond in Russian, no unsolicited comments). It's wired into both configs, not copy-pasted:

- opencode: listed first in `opencode.jsonc`'s `instructions` array, followed by
  `opencode/instructions.md` (opencode-specific residual: branch-scoped task workflow)
- Claude Code: pulled into `claude/CLAUDE.md` via `@` -import, followed by the Claude-specific
  residual (root-level task workflow, pointers to `settings.json`/`agents`/`commands/`)

Edit `shared/instructions-core.md` for anything that applies to both tools; edit
`opencode/instructions.md` or `claude/CLAUDE.md` only for what's genuinely tool-specific (they
differ on the task-file working directory: opencode uses `.opencode/work/<branch>/`, Claude Code
uses the project root).

Agents and commands are **not** unified this way: `opencode/agent/<name>.md` is the source of truth
for an agent's prompt body; when it changes, mirror the body into `claude/agents/<name>.md` by hand
(frontmatter stays tool-specific). Same for `opencode/commands/` ↔ `claude/commands/`. On the
codegraph side, `claude/agents/*` and `opencode/agent/*` have drifted (Claude copies are frozen at
`eaaa193`) — unification in EN is a separate planned task.

The CodeGraph instruction block (`<!-- CODEGRAPH_START/END -->`) exists in exactly one place —
the end of `shared/instructions-core.md`; both tools receive it through the wiring above. Never
add copies to `CLAUDE.md`, `instructions.md`, or `AGENTS.md`: if codegraph re-injects one, delete
it and keep the core copy.