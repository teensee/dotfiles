#!/usr/bin/env bash

# shellcheck disable=SC2034 # used by scripts sourcing this file
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
	.config/ghostty/config.ghostty
	"Library/Application Support/com.mitchellh.ghostty/config.ghostty"
	.config/lazygit
	.config/nvim
	.config/opencode
	.config/tmux/tmux.conf
	.config/tmuxinator
	.config/zed
	.claude/CLAUDE.md
	.claude/settings.json
	.claude/statusline-command.sh
	.claude/agents
	.claude/commands
	.claude/skills
)
