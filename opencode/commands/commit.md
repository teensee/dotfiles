---
description: Черновик сообщения коммита — по git diff и task-log.md текущего бранча
agent: build
subtask: true
model: opencode-go/deepseek-v4-flash
---

Определи текущий бранч: `git branch --show-current`; если пусто — `git rev-parse --abbrev-ref HEAD`.

Прочитай `.opencode/work/<branch>/task-log.md` и `task-plan.md` (если есть).

Выполни `git status` и `git diff` (только чтение) и на их основе составь сообщение коммита.

## Требования

- Conventional Commits: `type(scope): summary`
- Одно сообщение на задачу, summary до 72 символов
- Тело — детали из task-log.md (что сделано, миграции, тесты)
- НЕ выполняй `git add`/`git commit` — только предложи текст сообщения в блоке кода, пользователь
  коммитит сам
