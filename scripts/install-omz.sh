#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"

if [ -d "$ZSH_DIR/.git" ]; then
	log_ok "oh-my-zsh is already installed"
else
	log_info "Installing oh-my-zsh..."
	git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
	log_ok "oh-my-zsh installed"
fi

OMZ_CUSTOM_PLUGINS=(
	"zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions"
)

for entry in "${OMZ_CUSTOM_PLUGINS[@]}"; do
	plugin="${entry%% *}"
	repo="${entry#* }"
	dest="$ZSH_DIR/custom/plugins/$plugin"
	if [ -d "$dest" ]; then
		log_ok "Plugin $plugin is already installed"
	else
		log_info "Installing plugin $plugin..."
		git clone --depth=1 "$repo" "$dest"
		log_ok "Plugin $plugin installed"
	fi
done
