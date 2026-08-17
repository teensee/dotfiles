---
description: Очистка рабочих файлов задачи — удаляет .opencode/work/<branch>/
agent: build
subtask: true
model: opencode-go/deepseek-v4-pro
---

Определи текущий бранч: `git branch --show-current`; если пусто — `git rev-parse --abbrev-ref HEAD`.

Удали рабочую директорию задачи `.opencode/work/<branch>/` (команда `rm -rf` — будет запрошено
подтверждение).

НЕ трогай `.gitignore` — рабочие файлы и так игнорируются (`.opencode/work/`).

После удаления скажи: «Рабочие файлы задачи удалены».
