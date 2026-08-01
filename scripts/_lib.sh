#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

TARGETS=(
    .zshrc
    .gitconfig
    .gitconfig-etp
    .gitignore_global
    .ideavimrc
    .config/nvim
    .config/fish
    .config/ghostty/config
    .config/tmux/tmux.conf
    .config/htop/htoprc
    .config/lazygit
    .config/tmuxinator
    .config/opencode
    .config/zed
    .config/btop/btop.conf
    Brewfile
)
