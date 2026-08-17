---
description: План реализации — читает task.md и task-research.md текущего бранча, составляет task-plan.md
agent: architect
subtask: true
model: opencode-go/deepseek-v4-pro
---

Определи текущий бранч: `git branch --show-current`; если пусто — `git rev-parse --abbrev-ref HEAD`.

Рабочая директория задачи: `.opencode/work/<branch>/`.

Прочитай task.md и task-research.md из рабочей директории.

Следуй своему system prompt — там полная методология, чеклист и формат результата.

НЕ пиши код реализации. В плане — только скелет: интерфейсы, сигнатуры, SQL-схемы.

После создания файла скажи: «План готов → .opencode/work/<branch>/task-plan.md. Проверь, поправь если нужно, и запускай /go».
