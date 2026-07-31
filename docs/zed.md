# Zed

Zed editor config — symlinked as `~/.config/zed`.

## Config (`settings.json`)

- **Font**: JetBrainsMono Nerd Font (13px buffer, 16px UI)
- **Keymap**: JetBrains base + vim_mode enabled
- **Theme**: JetBrains Dark
- **Autosave**: 1s delay
- **Edit predictions**: subtle mode, zed provider
- **Git**: inline blame enabled, panel grouped by status sorted by path
- **Panel layout**: project/outline/collaboration/git on left, agent on right

### Agent servers

| Server | Type | Notes |
|---|---|---|
| `opencode` | registry | default mode: plan, effort: max |
| `github-copilot-cli` | registry | |
| `claude-acp` | registry | |

### Language servers

| Language | LSP | Formatter |
|---|---|---|
| PHP | intelephense (not phpactor) | `php-cs-fixer` via external command |
| Go | gopls (default) | format_on_save, hard_tabs, tab_size 4 |

## Structure

- `themes/` — custom Zed themes (JSON)
- `conversations/` — chat history (gitignored, runtime data)
- `prompts/` — prompts cache (gitignored, runtime data)
