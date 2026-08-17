---
description: Создание задачи — создаёт .opencode/work/<branch>/task.md для текущего бранча
agent: build
subtask: true
model: opencode-go/deepseek-v4-flash
---

Определи текущий бранч: `git branch --show-current`; если пусто — `git rev-parse --abbrev-ref HEAD`.

Рабочая директория задачи: `.opencode/work/<branch>/`.

Создай рабочую директорию (`mkdir -p` — будет запрошено подтверждение) и файл `task.md` с текстом задачи.

$ARGUMENTS

Если текст задачи пуст — спроси у пользователя описание задачи и запиши его в task.md.

После создания скажи: «Задача создана → .opencode/work/<branch>/task.md. Дополни описание при необходимости и запускай /res».
