---
description: Research task subagent — read-only except writing task-research.md and task-plan.md
mode: subagent
model: opencode-go/deepseek-v4-pro
permission:
  read: allow
  glob: allow
  grep: allow
  edit:
    "*": deny
    "**/task-research.md": allow
    "**/task-plan.md": allow
---
