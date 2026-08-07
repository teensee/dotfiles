#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

log_info() { echo "[*] $*"; }
log_ok() { echo "[+] $*"; }
log_err() { echo "[-] $*"; } >&2
log_warn() { echo "[!] $*"; }
log_hint() { echo "[i] $*"; }
log_item() { echo "    $*"; }

TARGETS=(
	.zshrc
	.gitconfig
	.gitconfig-etp
	.gitignore_global
	.ideavimrc
	Brewfile
	.config/btop/btop.conf
	.config/fish
	.config/ghostty/config
	.config/lazygit
	.config/nvim
	.config/opencode
	.config/tmux/tmux.conf
	.config/tmuxinator
	.config/zed
)
