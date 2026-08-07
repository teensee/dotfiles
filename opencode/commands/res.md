---
description: Ресёрч задачи — читает task.md, анализирует код, создаёт task-research.md
agent: research
subtask: true
model: opencode-go/deepseek-v4-pro
---

Прочитай task.md в корне проекта.

Следуй своему system prompt — там полная методология, чеклист и формат результата.

НЕ пиши код. НЕ предлагай решения. Только ресерч.

После создания файла скажи: «Ресерч завершён → task-research.md. Проверь и запускай /plan».
