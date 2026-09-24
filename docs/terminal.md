# Terminal & Utilities

## Tmux (`tmux/tmux.conf`)

Prefix: `Ctrl-B`. Key binds: `|`/`-` splits, `h/j/k/l` pane nav, `r` reload, `Tab` last window. TPM
installed by `install.conf.yaml`. Install plugins: `Prefix + I`.

TPM plugin path: `~/.config/tmux/plugins/` (set via `TMUX_PLUGIN_MANAGER_PATH` in `tmux.conf`).

## Ghostty (`ghostty/config.ghostty`)

Terminal emulator config. Dotbot links the same file to both paths Ghostty reads:

- `~/.config/ghostty/config.ghostty` (XDG) — loaded first
- `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` (macOS) — loaded second,
  overrides XDG

`config.ghostty` is the current file name (since Ghostty 1.2.3); the legacy `config` name is still
read but unused here. Reload at runtime: `cmd+shift+,`.

Key settings: SF Mono 15, theme `light:Dracula+,dark:Dracula` (auto light/dark), padding 12×8 with
`balance`/`extend`, `copy-on-select`.

## LazyGit (`lazygit/`)

Git TUI config.

## btop (`btop/btop.conf`)

Resource monitor. `save_config_on_exit = true` — changes made in UI persist to the config file (and
to the repo via symlink).

## Modern CLI Tools

Drop-in replacements for standard Unix tools. All support `--help`.

| Instead of | Use                        | Notes                                           |
| ---------- | -------------------------- | ----------------------------------------------- |
| `ls`       | `eza` / `ll` / `la` / `lt` | Drop-in. Extras: `--tree`, `--git`, icons       |
| `find`     | `fd`                       | `fd PATTERN` (regex), `fd -e go` (by extension) |
| `cd`       | `z DIR` (zoxide)           | Frecency-based; regular `cd` still works        |
| `git diff` | `delta`                    | Auto via gitconfig                              |
| `du`       | `dust`                     | `dust` (sorted tree), `dust -d 1` (one level)   |
| `df`       | `duf`                      | Pretty table, no args needed                    |
| `man`      | `tldr`                     | `tldr COMMAND` for usage examples               |

Structured data: `jq` for JSON, `yq` (mikefarah v4) for YAML — no hand-parsing with
`grep`/`sed`/`python -c`.

## IdeaVim (`vim/ideavimrc`)

Vim emulation for JetBrains IDEs.
