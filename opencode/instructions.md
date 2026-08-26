# Global OpenCode instructions

Правила для всех сессий opencode во всех проектах. Общая часть (git-policy, приоритет инструментов,
Postgres MCP, стиль) вынесена в `shared/instructions-core.md` — она же подключена к
`opencode.jsonc` (`instructions`) и к Claude Code (`CLAUDE.md`). Здесь остаётся только то, что
специфично для opencode.

## Task workflow

Рабочие файлы задач лежат в заигноренной директории `.opencode/work/<текущий-бранч>/`:

- `task.md` — описание задачи (создаётся командой `/task`)
- `task-research.md` — ресёрч (команда `/res`)
- `task-plan.md` — план реализации (команда `/plan`)
- `task-log.md` — лог реализации (команда `/go`)

Пайплайн: `/task → /res → /plan → /go → /review → /clean`.

Текущий бранч определяй через `git branch --show-current` (если пусто —
`git rev-parse --abbrev-ref HEAD`). Рабочую директорию не коммить — `.opencode/` в проектах
игнорируется.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
