# Git

## Config files

| File               | Purpose                                                                                     |
| ------------------ | ------------------------------------------------------------------------------------------- |
| `gitconfig`        | Identity (vlad / stimulmonk@yandex.ru), `stats` alias                                       |
| `gitconfig-etp`    | Conditional includes for `~/PhpstormProjects/projects/etp/` and `~/Programming/Go/elk_hub/` |
| `gitignore_global` | macOS (.DS_Store) + Claude Code (.claude) patterns                                          |

## Per-host overrides

`gitconfig-local` and `gitconfig-work` are **not tracked**. Copy from examples:

```
cp git/gitconfig-local.example git/gitconfig-local
cp git/gitconfig-work.example git/gitconfig-work
```
