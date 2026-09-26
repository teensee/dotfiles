# Глобальные инструкции Claude Code

Правила для всех сессий Claude Code во всех проектах. Общая часть (git-policy, приоритет
инструментов, Postgres MCP, стиль) вынесена в `shared/instructions-core.md` и подключена ниже — тот
же файл используется в opencode (`opencode/instructions.md`). Правь общую часть только там, здесь —
только то, что специфично для Claude Code.

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
- Список агентов — `~/.claude/agents/`, команд — `~/.claude/commands/`, скиллов —
  `~/.claude/skills/`
