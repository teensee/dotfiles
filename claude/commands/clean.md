Определи текущий бранч: `git branch --show-current`; если пусто — `git rev-parse --abbrev-ref HEAD`.
Рабочая директория задачи: `.opencode/work/<branch>/`.

Удали директорию задачи целиком (в ней task.md, task-research.md, task-plan.md, task-log.md).

## .gitignore

Убедись, что `.opencode/` в `.gitignore` проекта — рабочие файлы не попадают в коммиты:

```
.opencode/
```

А вот команды и агентов — наоборот, коммить:

```
# коммитим
.claude/commands/
.claude/agents/
CLAUDE.md
```
