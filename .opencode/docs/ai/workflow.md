# OpenCode workflow

Это флоу **opencode** — файлы задач branch-scoped (`.opencode/work/<branch>/`). Claude Code в этом
репо ведёт те же файлы в корне проекта (root-level `task.md` и т.д.) — см.
[claude-code.md](claude-code.md).

Таск-флоу по бранчам: `/task → /res → /plan → /go → /review → /clean`.

Рабочие файлы задачи лежат в заигноренной директории `.opencode/work/<branch>/` (бранч текущий):

| Команда    | Агент         | Действие                                                                             |
| ---------- | ------------- | ------------------------------------------------------------------------------------ |
| `/task`    | build         | создаёт `.opencode/work/<branch>/task.md` (описание из аргументов или запросом)      |
| `/res`     | research      | читает `task.md`, анализирует код, создаёт `task-research.md`                        |
| `/plan`    | architect     | читает research, изучает паттерны, создаёт `task-plan.md` (скелеты, без кода)        |
| `/go`      | build         | делегирует шаги плана специалистам (go-dev, symfony-dev, ...), создаёт `task-log.md` |
| `/review`  | code-reviewer | ревью `git diff` против плана, отчёт по критичности                                  |
| `/clean`   | build         | удаляет `.opencode/work/<branch>/`                                                   |
| `/pg-ro`   | build         | напоминалка: рецепт read-only пользователя Postgres для MCP                          |
| `/yt-comm` | build         | комментарий к задаче YouTrack со ссылками на MR по текущей ветке                     |

Правила:

- Один бранч = одна задача; текущий бранч определяет контекст (переключил бранч — переключил задачу)
- `.opencode/` в рабочих проектах gitignored целиком; если в проекте он не игнорируется — добавь
  `.opencode/work/` в `.gitignore`
- Git — только чтение для агента: `status/diff/log/show/branch -l/remote/rev-parse/...`; все
  операции записи (add/commit/push/checkout/...) выполняет пользователь
- Права (read-only агенты и т.п.) объявляются ТОЛЬКО в `agent/*.md`, команды наследуют их через
  `agent: X` — не дублировать
- MCP `postgres` (read-only, `enabled: false` глобально) включается в проектном `opencode.jsonc`;
  подключение берётся из env `DATABASE_OPENCODE_RO_URI` (read-only роль БД, `GRANT SELECT` +
  `default_transaction_read_only`); инструменты `postgres_query`/`postgres_schema` используются
  агентами ТОЛЬКО если сервер включён в текущем проекте
- Приоритет инструментов — 4 ступени (codegraph → встроенные Grep/Glob → `rg`/`fd` → `grep`/`find`);
  определён в `shared/instructions-core.md`, действует на всех агентов, включая субагентов

## Per-tool reference

- [docs/nvim.md](../../../docs/nvim.md)
- [docs/zed.md](../../../docs/zed.md)
- [docs/git.md](../../../docs/git.md)
- [docs/shell.md](../../../docs/shell.md)
- [docs/terminal.md](../../../docs/terminal.md)
- [docs/opencode.md](../../../docs/opencode.md)
