# Глобальные инструкции Claude Code

Правила для всех сессий Claude Code во всех проектах. Общая часть (git-policy, приоритет
инструментов, task workflow, Postgres MCP, стиль) вынесена в `opencode/AGENTS.md` — тот же файл
используют opencode и pi. Правь общую часть только там, здесь — только то, что специфично для
Claude Code.

@/Users/vladislav/.dotfiles/opencode/AGENTS.md

## Claude Code specifics

- Права (`permissions.allow`/`permissions.deny` для git) заданы в `~/.claude/settings.json`
- Список агентов — `~/.claude/agents/`, команд — `~/.claude/commands/`, скиллов — `~/.claude/skills/`
- Команды и агентов (`.claude/commands/`, `.claude/agents/`, `CLAUDE.md`) — коммить
