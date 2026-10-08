# Git

## Post-install

Copy example git configs (per-host overrides, not tracked):

```
cp git/gitconfig-local.example git/gitconfig-local
cp git/gitconfig-work.example git/gitconfig-work
```

## Merge / diff tool

`git/gitconfig` sets VS Code as `merge.tool` / `diff.tool` via the absolute CLI path
`/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code` (VS Code is not in the
Brewfile, `code` is not on `PATH`). If VS Code is reinstalled elsewhere, update both `cmd` lines.
