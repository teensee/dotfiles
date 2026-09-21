# CLI Tools

Modern replacements for standard Unix tools.

| Instead of | Use                        | Notes                                                             |
| ---------- | -------------------------- | ----------------------------------------------------------------- |
| `ls`       | `eza` / `ll` / `la` / `lt` | Drop-in compatible. Extras: `--tree`, `--git`, icons              |
| `find`     | `fd`                       | Different syntax: `fd PATTERN` (regex), `fd -e go` (by extension) |
| `cd`       | `z DIR` (zoxide)           | Frecency-based jumping; regular `cd` still works                  |
| `git diff` | `delta`                    | Transparent — auto via gitconfig                                  |
| `du`       | `dust`                     | `dust` (sorted tree), `dust -d 1` (one level)                     |
| `df`       | `duf`                      | Pretty table, no args needed                                      |
| `man`      | `tldr`                     | `tldr COMMAND` — usage examples, not full docs                    |

## Structured data

Never hand-parse JSON/YAML with `grep`/`sed`/`awk`/`python -c`:

- **JSON** — `jq` (`jq '.a.b' file.json`, `-r` for raw strings)
- **YAML** — `yq`, mikefarah v4 with `jq`-like syntax (`yq '.a.b' file.yaml`, `yq -i` edits in place)
