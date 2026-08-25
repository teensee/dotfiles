Удали файлы текущей задачи:

- task-research.md
- task-plan.md
- task-log.md

Очисти:
- task.md

## .gitignore

Добавь в `.gitignore`, чтобы рабочие файлы не попадали в коммиты:

```
task.md
task-research.md
task-plan.md
task-log.md
```

А вот команды и агентов — наоборот, коммить:

```
# коммитим
.claude/commands/
.claude/agents/
CLAUDE.md
```
