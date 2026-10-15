# Global instructions (opencode ↔ Claude Code ↔ pi)

`opencode/AGENTS.md` (= `~/.config/opencode/AGENTS.md` through the dotbot symlink) is the single
source of truth for the rules shared by the tools: read-only git policy, the
codegraph → Grep/Glob → `rg`/`fd` → `grep`/`find` tool-priority ladder, `jq`/`yq` for JSON/YAML
(never hand-parse), conditional Postgres MCP usage, the branch-scoped task workflow, and style
(respond in Russian, no unsolicited comments). OpenCode v2 loads `AGENTS.md` natively (the
`instructions` config array is ignored since v2); the other harnesses are wired to the same file,
not copy-pasted:

- opencode: `AGENTS.md` is discovered automatically as the global instruction file
- Claude Code: pulled into `claude/CLAUDE.md` via `@`-import, followed by the Claude-specific
  residual (pointers to `settings.json` / `agents` / `commands`)
- pi: `pi/extensions/core.ts` appends it to the system prompt (planned — see [pi.md](pi.md))

Edit `opencode/AGENTS.md` for anything that applies to all tools; edit `claude/CLAUDE.md` only for
what's genuinely Claude-specific. (Until the OpenCode v2 migration on 2026-10-14 this was split
between `shared/instructions-core.md` and `opencode/instructions.md` — see
[opencode-v2-migration.md](opencode-v2-migration.md).)

Agents and commands are **not** unified this way: `opencode/agents/<name>.md` is the source of truth
for an agent's prompt body; when it changes, mirror the body into `claude/agents/<name>.md` by hand
(frontmatter stays tool-specific). Same for `opencode/commands/` ↔ `claude/commands/`. On the
codegraph side, `claude/agents/*` and `opencode/agents/*` have drifted (Claude copies are frozen at
`eaaa193`) — unification in EN is a separate planned task.

Planned: the manual agent/command mirroring described above is replaced by a generated
harness-independent build (opencode sources -> Claude Code / pi) — see
[harness-build.md](harness-build.md).

The CodeGraph instruction block (`<!-- CODEGRAPH_START/END -->`) exists in exactly one place —
the end of `opencode/AGENTS.md`; all tools receive it through the wiring above. Never add copies to
`CLAUDE.md` or elsewhere: if codegraph re-injects one, delete it and keep the AGENTS.md copy.
