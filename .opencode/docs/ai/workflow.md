# OpenCode workflow

Таск-флоу по бранчам: `/task → /res → /plan → /go → /review → /clean`.

Рабочие файлы задачи лежат в заигноренной директории `.opencode/work/<branch>/` (бранч текущий):

| Команда | Агент | Действие |
|---|---|---|
| `/task` | build | создаёт `.opencode/work/<branch>/task.md` (описание из аргументов или запросом) |
| `/res` | research | читает `task.md`, анализирует код, создаёт `task-research.md` |
| `/plan` | architect | читает research, изучает паттерны, создаёт `task-plan.md` (скелеты, без кода) |
| `/go` | build | делегирует шаги плана специалистам (go-dev, symfony-dev, ...), создаёт `task-log.md` |
| `/review` | code-reviewer | ревью `git diff` против плана, отчёт по критичности |
| `/clean` | build | удаляет `.opencode/work/<branch>/` |
| `/pg-ro` | build | напоминалка: рецепт read-only пользователя Postgres для MCP |

Правила:

- Один бранч = одна задача; текущий бранч определяет контекст (переключил бранч — переключил задачу)
- `.opencode/` в рабочих проектах gitignored целиком; если в проекте он не игнорируется — добавь
  `.opencode/work/` в `.gitignore`
- Git — только чтение для агента: `status/diff/log/show/branch -l/remote/rev-parse/...`; все
  операции записи (add/commit/push/checkout/...) выполняет пользователь
- Права (read-only агенты и т.п.) объявляются ТОЛЬКО в `agent/*.md`, команды наследуют их через
  `agent: X` — не дублировать
- MCP `postgres` (read-only, `enabled: false` глобально) включается в проектном `opencode.jsonc`;
  подключение берётся из env `DATABASE_OPENCODE_RO_URI` (read-only роль БД, `GRANT SELECT` + `default_transaction_read_only`)

## Per-tool reference

- [docs/nvim.md](../../../docs/nvim.md)
- [docs/zed.md](../../../docs/zed.md)
- [docs/git.md](../../../docs/git.md)
- [docs/shell.md](../../../docs/shell.md)
- [docs/terminal.md](../../../docs/terminal.md)
- [docs/opencode.md](../../../docs/opencode.md)
