# Zed

Zed editor config — symlinked as `~/.config/zed`.

## Config (`settings.json`)

- **Font**: JetBrainsMono Nerd Font (13px buffer/terminal, 16px UI)
- **Keymap**: JetBrains base + vim_mode enabled
- **Theme**: Catppuccin Mocha - No Italics (dark), One Light (light)
- **Icon theme**: Colored Zed Icons Theme Dark
- **Autosave**: 1s delay
- **Edit predictions**: subtle mode, zed provider, data collection off
- **Inline edit predictions**: disabled (`show_edit_predictions: false`)
- **Git**: inline blame enabled, panel grouped by status sorted by path, tree_view off
- **Panel layout**: project/outline/collaboration/git on left, agent/terminal on right
- **Venv detection**: `terminal.detect_venv` on, search order `.venv`, `venv`, `.env`, `env`
- **Soft wrap**: none (global), `prefer_line` for Markdown
- **Diff view**: unified
- **JSON**: `tab_size` 2, indent guides (1px)
- **Wrap guides**: enabled
- **Gutter**: folds on, bookmarks off
- **Restore on startup**: launchpad
- **Prettier**: enabled (built-in); repo-root `.prettierrc.json` sets `*.md` `proseWrap: always` +
  `printWidth: 100` (hard-wrap at 100 chars)
- **Telemetry**: diagnostics on, metrics off, anthropic retention off

### Agent servers

| Server               | Type     | Notes                                                          |
| -------------------- | -------- | -------------------------------------------------------------- |
| `opencode`           | registry | default model: `deepseek-v4.1-flash`, mode: build, effort: max |
| `github-copilot-cli` | registry |                                                                |
| `claude-acp`         | registry |                                                                |

### Language servers

| Language | LSP                         | Formatter                             |
| -------- | --------------------------- | ------------------------------------- |
| PHP      | intelephense (not phpactor) | `php-cs-fixer` via external command   |
| Go       | gopls (default)             | format_on_save, hard_tabs, tab_size 4 |

## Structure

- `settings.json` — editor config
- `keymap.json` — custom keybindings on top of the JetBrains base keymap (currently: ⌥⌘C → "Copy:
  PHP FQCN")
- `tasks.json` — global tasks:
  - **Scratch presets** (PHP/Go/SQL/JSON/YAML/Markdown/Shell/Python/TypeScript/HTTP/Hurl) — create
    the next free `~/Programming/scratches/scratch_N.<ext>` and open it in Zed
  - **Create generators** (PHP class/enum/interface) — fill the current empty `.php` file with a
    skeleton, deriving class name from the filename and the namespace from the project's
    `composer.json` PSR-4 (via `$ZED_FILE`)
  - **Copy: PHP FQCN** — PhpStorm-style "Copy Reference": copies the fully qualified class name of
    the symbol under the caret (via `$ZED_FILE` + `$ZED_SYMBOL`) to the clipboard, bound to ⌥⌘C
- `tasks/scratch/scratch.sh` — helper script: `scratch.sh <ext> [template]` — numbering, copies
  template (or empty file), opens in Zed. For `go` creates an isolated module
  `go/scratch_N/{go.mod, main.go}` instead of a flat file
- `tasks/scratch/scratch-dir.sh` — opens `~/Programming/scratches`
- `tasks/scratch/_templates/*.tpl` — file templates for scratch presets (also used by the nvim
  `:Scratch` command, see `docs/nvim.md`)
- `tasks/create/php/lib.php` — `ZedCreate\Php\Generator` class: guards (must be a `.php` file, must
  be empty), resolves the namespace from the nearest `composer.json` (longest-match over
  `autoload.psr-4` + `autoload-dev.psr-4`), renders the skeleton via heredoc (`class` →
  `final readonly` + empty constructor, `enum`/`interface` → plain declaration) and returns a caret
  position (`line:col`) for the constructor
- `tasks/create/php/class.php` / `enum.php` / `interface.php` — thin wrappers calling
  `Generator::run(<kind>, $argv)` on `$ZED_FILE`; refuse to touch a non-empty file. `class.php`
  moves the caret into the constructor via `zed --existing "$ZED_FILE:line:col"`. Adding a new kind
  = a wrapper script + a `tasks.json` entry
- `tasks/copy-reference/php.php` — `ZedCopyReference\Php\ReferenceCopier`: derives the short symbol
  name from `$ZED_SYMBOL`'s breadcrumb (first segment, keyword stripped; falls back to the
  filename), reads the `namespace` statement directly from the file, and pipes the resulting FQCN to
  `pbcopy`
- `themes/` — custom Zed themes (JSON, gitignored except `.gitkeep`)
- `conversations/` — chat history (gitignored, runtime data)
- `prompts/` — prompts cache (gitignored, runtime data)
