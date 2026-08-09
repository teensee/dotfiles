# OpenCode workflow

`/res → /plan → /go → /review → /clean`:

1. **`/res`** (research-agent) — reads `task.md`, analyzes codebase, creates `task-research.md`
2. **`/plan`** (architect-agent) — reads research, studies patterns, creates `task-plan.md` (signatures, SQL, config — no implementation)
3. **`/go`** (build-agent) — dispatches plan steps to specialized subagents (go-dev, symfony-dev, etc.), creates `task-log.md`
4. **`/review`** (code-reviewer agent) — reviews `git diff` against plan, outputs findings
5. **`/clean`** (build-agent) — removes `task-*.md` files

## Per-tool reference

- [docs/nvim.md](../../../docs/nvim.md)
- [docs/zed.md](../../../docs/zed.md)
- [docs/git.md](../../../docs/git.md)
- [docs/shell.md](../../../docs/shell.md)
- [docs/terminal.md](../../../docs/terminal.md)
- [docs/opencode.md](../../../docs/opencode.md)
