# OpenCode

AI coding agent configuration — symlinked to `~/.config/opencode`.

## Config files

| File             | Purpose                                                                                                                                                                                                                                                                                                                             |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `opencode.jsonc` | Model `opencode-go/deepseek-v4-flash`, custom `vesna` provider (`@ai-sdk/openai-compatible`, VesnaCode, key via `VESNA_API_KEY` env), LSP enabled, MCP `codegraph` server, git permission rules (destructive commands denied) — model per subagent задаётся в `agent/*.md` |
| `tui.jsonc`      | Mouse disabled, vim-like Ctrl+U/D scroll                                                                                                                                                                                                                                                                                            |

## Subagents (`agent/`)

| Agent              | Purpose                                                |
| ------------------ | ------------------------------------------------------ |
| `architect`        | Составляет task-plan.md по task-research.md            |
| `code-reviewer`    | Ревью кода: безопасность, качество, производительность |
| `dba`              | PostgreSQL: запросы, индексы, миграции, HA             |
| `debugger`         | Системная отладка, root cause analysis                 |
| `devops`           | Docker, K8s, CI/CD, bash, nginx, мониторинг            |
| `go-dev`           | Go: микросервисы, конкурентность, CLI, RabbitMQ        |
| `python-pro`       | Python 3.11+, FastAPI, SQLAlchemy, Pydantic            |
| `research`         | Анализ кодовой базы, создание task-research.md         |
| `rust-engineer`    | Rust: systems, CLI, FFI, tokio                         |
| `security-auditor` | Аудит безопасности (read-only)                         |
| `symfony-dev`      | PHP/Symfony/Doctrine/Messenger                         |
| `test-writer`      | Тесты: Codeception, PHPUnit, Go table-driven           |
| `zig-dev`          | Zig: systems, C interop, comptime                      |

Модели: reasoning-агенты (`research`, `architect`, `code-reviewer`, `debugger`, `security-auditor`) — `deepseek-v4-pro`; `dba` — `glm-5`; имплементеры и `test-writer` — `deepseek-v4-flash`.

## Slash commands (`commands/`)

| Command   | Agent         | Purpose                                      |
| --------- | ------------- | -------------------------------------------- |
| `/res`    | research      | Ресёрч: task.md → task-research.md           |
| `/plan`   | architect     | План: task-research.md → task-plan.md        |
| `/go`     | build         | Реализация: план → делегирование спецагентам |
| `/review` | code-reviewer | Ревью: git diff + план → отчёт               |
| `/clean`  | build         | Очистка task-\*.md                           |

## Structure

- `skills/` — vendored [superpowers](https://github.com/obra/superpowers) skills (markdown + scripts), no plugin dependency; snapshot, updates manual. MIT © 2025 Jesse Vincent — `skills/LICENSE`
- `plugin/` — reserved for local plugins
- Dependencies: `package.json` + `node_modules` (ignored, not tracked)
- `rework-agents.md` — план доработки агентов (чеклист)
