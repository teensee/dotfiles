# OpenCode

AI coding agent configuration — symlinked to `~/.config/opencode`.

## Config files

| File             | Purpose                                                                                                                                                                                   |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `opencode.jsonc` | Model (`opencode-go/deepseek-v4-pro`), LSP enabled, [superpowers](https://github.com/obra/superpowers) plugin, MCP `codegraph` server, git permission rules (destructive commands denied) |
| `tui.jsonc`      | Mouse disabled, vim-like Ctrl+U/D scroll                                                                                                                                                  |

## Subagents (`agent/`)

`dba`, `devops`, `go-dev`, `research`, `symfony-dev`, `test-writer`

## Slash commands (`commands/`)

`clean`, `go`, `plan`, `res`

## Structure

- `plugin/` — reserved for local plugins
- Dependencies: `package.json` + `node_modules` (ignored, not tracked)
