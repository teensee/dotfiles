---
description: План реализации — читает task.md и task-research.md, составляет task-plan.md
agent: architect
subtask: true
model: opencode-go/deepseek-v4-pro
---

Прочитай task.md и task-research.md в корне проекта.

Следуй своему system prompt — там полная методология, чеклист и формат результата.

НЕ пиши код реализации. В плане — только скелет: интерфейсы, сигнатуры, SQL-схемы.

После создания файла скажи: «План готов → task-plan.md. Проверь, поправь если нужно, и запускай /go».
