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
