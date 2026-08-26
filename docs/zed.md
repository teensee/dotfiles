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

- `settings.json` — editor config
- `tasks.json` — global tasks:
  - **Scratch presets** (PHP/Go/SQL/JSON/YAML/Markdown/Shell/Python/TypeScript/HTTP/Hurl) — create the next free `~/Programming/scratches/scratch_N.<ext>` and open it in Zed
  - **Create generators** (PHP class/enum/interface) — fill the current empty `.php` file with a skeleton, deriving class name from the filename and the namespace from the project's `composer.json` PSR-4 (via `$ZED_FILE`)
- `tasks/scratch/scratch.sh` — helper script: `scratch.sh <ext> [template]` — numbering, copies template (or empty file), opens in Zed. For `go` creates an isolated module `go/scratch_N/{go.mod, main.go}` instead of a flat file
- `tasks/scratch/scratch-dir.sh` — opens `~/Programming/scratches`
- `tasks/scratch/_templates/*.tpl` — file templates for scratch presets
- `tasks/create/php/lib.php` — `ZedCreate\Php\Generator` class: guards (must be a `.php` file, must be empty), resolves the namespace from the nearest `composer.json` (longest-match over `autoload.psr-4` + `autoload-dev.psr-4`), renders the skeleton via heredoc
- `tasks/create/php/class.php` / `enum.php` / `interface.php` — thin wrappers calling `Generator::run(<kind>, $argv)` on `$ZED_FILE`; refuse to touch a non-empty file. Adding a new kind = a wrapper script + a `tasks.json` entry
- `themes/` — custom Zed themes (JSON, gitignored except `.gitkeep`)
- `conversations/` — chat history (gitignored, runtime data)
- `prompts/` — prompts cache (gitignored, runtime data)
