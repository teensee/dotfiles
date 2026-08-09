# Terminal & Utilities

## Tmux (`tmux/tmux.conf`)

Prefix: `Ctrl-B`. Key binds: `|`/`-` splits, `h/j/k/l` pane nav, `r` reload, `Tab` last window. TPM installed by `install.conf.yaml`. Install plugins: `Prefix + I`.

TPM plugin path: `~/.config/tmux/plugins/` (set via `TMUX_PLUGIN_MANAGER_PATH` in `tmux.conf`).

## Ghostty (`ghostty/config`)

Terminal emulator config.

## LazyGit (`lazygit/`)

Git TUI config.

## btop (`btop/btop.conf`)

Resource monitor. `save_config_on_exit = true` — changes made in UI persist to the config file (and to the repo via symlink).

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

## IdeaVim (`vim/ideavimrc`)

Vim emulation for JetBrains IDEs.
