# Global OpenCode instructions

Правила для всех сессий opencode во всех проектах.

## Git — только чтение

Агент работает с git **ИСКЛЮЧИТЕЛЬНО read-only**. Никогда не выполняй операции записи.

Разрешено: `git status`, `git diff`, `git log`, `git show`, `git branch -l/-a/-r`, `git remote`,
`git rev-parse`, `git rev-list`, `git blame`, `git grep`, `git stash list/show`, `git tag -l`,
`git config`.

Запрещено (выполняет только пользователь): `git add`, `git commit`, `git push`, `git pull`,
`git fetch`, `git checkout`, `git switch`, `git merge`, `git rebase`, `git reset`, `git restore`,
`git stash pop`, `git clean`, `git rm`.

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

## Приоритет инструментов

Трёхступенчатая лестница приоритетов для поиска и исследования кода. Применяется ко всем агентам,
включая субагентов.

1. **Codegraph** (высший приоритет) — если у проекта есть `.codegraph/` (проверь
   `codegraph_codegraph_explore` с `projectPath`, вернул ли он данные): работай через
   `codegraph_codegraph_explore` / `codegraph_node` — символы, call paths и исходники одним вызовом.
2. **`rg` / `fd`** — если codegraph недоступен (нет индекса; репо-«солянки» конфигов, например
   `~/.dotfiles`; непроиндексированные проекты): это нормально и ожидаемо. Ищи по содержимому через
   **`rg`**, файлы через **`fd`** — вместо `grep`/`find`: это современные и быстрее инструменты
   хост-машины (Grep/Glob-инструменты opencode и так работают на ripgrep). `find` и `grep` не
   используй, если доступны `fd`/`rg`.
3. **`grep` / `find`** — только если `rg`/`fd` отсутствуют в системе.

**Postgres MCP** — используется **только если включён/доступен в текущем проекте** (сервер настроен
не во всех проектах). Проверь наличие инструментов `postgres_query` / `postgres_schema` в своём
toolset:

- Доступны → ОБЯЗАТЕЛЬНО используй их для схемы БД, `EXPLAIN ANALYZE`, `pg_stat_*` (read-only).
- Недоступны → не выдумывай схему: опирайся на `migrations/`, Doctrine-сущности, `.sql`-файлы.

## Стиль

- Отвечай на русском, если пользователь пишет по-русски
- Не добавляй комментарии в код без запроса
- После изменения конфигурации проверь, что AGENTS.md и docs/ репозитория остались актуальными
