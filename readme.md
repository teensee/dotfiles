# My Dotfiles

Personal macOS configuration for Go/PHP development.

## Installation

```bash
git clone git@github.com:teensee/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

## Update

```bash
cd ~/.dotfiles
make update
```

## Post-install steps

Copy example git configs and fill in credentials:

```bash
cp git/gitconfig-local.example git/gitconfig-local
cp git/gitconfig-work.example git/gitconfig-work
```

Restart terminal to apply shell changes.

## What's included

- **Neovim** — NvChad v2.5, LSP (Go, PHP, Python), DAP, neotest, blink.cmp
- **Zsh** — Oh-My-Zsh + bureau theme, fzf, thefuck, asdf shims
- **Tmux** — Dracula theme, vim navigation, TPM
- **Git** — global config, conditional includes for work/personal projects
- **Ghostty** — terminal emulator config
- **Homebrew** — full toolchain: go, php, node, python, lazygit, lazydocker, k6, etc.

See [documentation.md](documentation.md) for detailed reference.

## License

Unlicense
