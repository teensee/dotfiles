# Zed

Zed editor config — symlinked as `~/.config/zed`.

## Config (`settings.json`)

- **Font**: JetBrainsMono Nerd Font (13px buffer/terminal, 16px UI)
- **Keymap**: JetBrains base + vim_mode enabled
- **Theme**: One Dark Pro (dark), One Light (light)
- **Icon theme**: Colored Zed Icons Theme Dark
- **Autosave**: 1s delay
- **Edit predictions**: subtle mode, zed provider, data collection off
- **Inline edit predictions**: disabled (`show_edit_predictions: false`)
- **Git**: inline blame enabled, panel grouped by status sorted by path, tree_view off
- **Panel layout**: project/outline/collaboration/git on left, agent/terminal on right
- **Soft wrap**: none (global), `prefer_line` for Markdown
- **Wrap guides**: enabled
- **Gutter**: folds on, bookmarks off
- **Restore on startup**: launchpad
- **Prettier**: enabled (built-in), markdown hard-wrap 120 chars via `.prettierrc.json` in repo root
- **Telemetry**: diagnostics on, metrics off, anthropic retention off

### Agent servers

| Server | Type | Notes |
|---|---|---|
| `opencode` | registry | default model: `deepseek-v4-flash`, mode: build, effort: max |
| `github-copilot-cli` | registry | |
| `claude-acp` | registry | |

### Language servers

| Language | LSP | Formatter |
|---|---|---|
| PHP | intelephense (not phpactor) | `php-cs-fixer` via external command |
| Go | gopls (default) | format_on_save, hard_tabs, tab_size 4 |

## Structure

- `themes/` — custom Zed themes (JSON, gitignored except `.gitkeep`)
- `conversations/` — chat history (gitignored, runtime data)
- `prompts/` — prompts cache (gitignored, runtime data)
