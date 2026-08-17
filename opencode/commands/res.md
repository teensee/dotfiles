---
description: Ресёрч задачи — читает task.md текущего бранча, анализирует код, создаёт task-research.md
agent: research
subtask: true
model: opencode-go/deepseek-v4-pro
---

Определи текущий бранч: `git branch --show-current`; если пусто — `git rev-parse --abbrev-ref HEAD`.

Рабочая директория задачи: `.opencode/work/<branch>/`. Если её нет — создай (`mkdir -p`), затем прочитай `.opencode/work/<branch>/task.md`.

Следуй своему system prompt — там полная методология, чеклист и формат результата.

НЕ пиши код. НЕ предлагай решения. Только ресерч.

После создания файла скажи: «Ресерч завершён → .opencode/work/<branch>/task-research.md. Проверь и запускай /plan».
