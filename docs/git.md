# Git

## Config files

| File               | Purpose                                                                                     |
| ------------------ | ------------------------------------------------------------------------------------------- |
| `gitconfig`        | Identity (vlad / stimulmonk@yandex.ru), `stats` alias, VS Code as merge/diff tool           |
| `gitconfig-etp`    | Conditional includes for `~/PhpstormProjects/projects/etp/` and `~/Programming/Go/elk_hub/` |
| `gitignore_global` | macOS (.DS_Store) + Claude Code (.claude) patterns                                          |

## Merge / diff tool

`merge.tool` and `diff.tool` are set to VS Code (`vscode`). `delta` stays the pager for `git diff`.

```
git mergetool           # 3-way merge editor for each conflicted file (Incoming | Current, result below)
git difftool [<rev>]    # per-file diff tabs
git difftool -d [<rev>] # whole-directory diff
```

- The CLI is called by absolute path —
  `/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code` — because VS Code is
  installed manually and `code` is not on `PATH`. If VS Code moves, update `git/gitconfig`.
- `mergetool.keepBackup = false` (no `*.orig`), prompts disabled, `trustExitCode = false` (`code`
  always exits 0, so git checks whether the merged file changed).

## Per-host overrides

`gitconfig-local` and `gitconfig-work` are **not tracked**. Copy from examples:

```
cp git/gitconfig-local.example git/gitconfig-local
cp git/gitconfig-work.example git/gitconfig-work
```
