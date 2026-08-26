# Глобальные инструкции Claude Code

Правила для всех сессий Claude Code во всех проектах. Общая часть (git-policy, приоритет
инструментов, Postgres MCP, стиль) вынесена в `shared/instructions-core.md` и подключена ниже —
тот же файл используется в opencode (`opencode/instructions.md`). Правь общую часть только там,
здесь — только то, что специфично для Claude Code.

@/Users/vladislav/.dotfiles/shared/instructions-core.md

## Task workflow

Пайплайн задач (одинаковый в opencode и здесь): `/task → /res → /plan → /go → /review → /clean`.

Рабочие файлы задачи лежат в корне текущего проекта (в отличие от opencode, без branch-scoped
директории):

- `task.md` — описание задачи (`/task`)
- `task-research.md` — ресёрч (`/res`, агент `research`)
- `task-plan.md` — план реализации (`/plan`, агент `architect`)
- `task-log.md` — лог реализации (`/go`)

Добавь эти файлы в `.gitignore` проекта, если их там ещё нет — рабочие файлы задачи не коммитятся.
Команды и агентов (`.claude/commands/`, `.claude/agents/`, `CLAUDE.md`) — наоборот, коммить.

## Claude Code specifics

- Права (`permissions.allow`/`permissions.deny` для git) заданы в `~/.claude/settings.json`
- Список агентов — `~/.claude/agents/`, команд — `~/.claude/commands/`, скиллов — `~/.claude/skills/`

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->
