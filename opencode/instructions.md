# Global OpenCode instructions

Правила для всех сессий opencode во всех проектах. Общая часть (git-policy, приоритет инструментов,
Postgres MCP, стиль) вынесена в `shared/instructions-core.md` — она же подключена к `opencode.jsonc`
(`instructions`) и к Claude Code (`CLAUDE.md`). Здесь остаётся только то, что специфично для
opencode.

## Task workflow

Рабочие файлы задач лежат в заигноренной директории `.opencode/work/<текущий-бранч>/`:

- `task.md` — описание задачи (создаётся командой `/task`)
- `task-research.md` — ресёрч (команда `/res`)
- `task-plan.md` — план реализации (команда `/plan`)
- `task-log.md` — лог реализации (команда `/go`)

Пайплайн: `/task → /res → /plan → /go → /review-task → /clean`.

Текущий бранч определяй через `git branch --show-current` (если пусто —
`git rev-parse --abbrev-ref HEAD`). Рабочую директорию не коммить — `.opencode/` в проектах
игнорируется.
