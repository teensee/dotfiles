---
description: Очистка рабочих файлов задачи — удаляет task-*.md и обновляет .gitignore
agent: build
subtask: true
model: opencode-go/deepseek-v4-pro
---

Удали файлы текущей задачи:

- task-research.md
- task-plan.md
- task-log.md

Очисти:
- task.md

Добавь в `.gitignore` чтобы рабочие файлы не попадали в коммиты:
```
task.md
task-research.md
task-plan.md
task-log.md
```

А вот команды и агентов opencode — наоборот, коммить:
```
# коммитим
.opencode/commands/
.opencode/agents/
AGENTS.md
```
