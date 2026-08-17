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

Пайплайн: `/task → /res → /plan → /go → /review → /commit → /clean`.

Текущий бранч определяй через `git branch --show-current` (если пусто —
`git rev-parse --abbrev-ref HEAD`). Рабочую директорию не коммить — `.opencode/` в проектах
игнорируется.

## Стиль

- Отвечай на русском, если пользователь пишет по-русски
- Не добавляй комментарии в код без запроса
- После изменения конфигурации проверь, что AGENTS.md и docs/ репозитория остались актуальными
