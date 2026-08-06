#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

BREWFILE="$DOTFILES_DIR/brew/Brewfile"

if [ ! -f "$BREWFILE" ]; then
	log_warn "Brewfile not found at $BREWFILE"
	exit 0
fi

if brew bundle check --file="$BREWFILE" &>/dev/null; then
	log_ok "Homebrew packages are up to date"
else
	log_warn "Homebrew packages are out of sync with Brewfile"
	printf "Run brew bundle install? [y/N] "
	read -r answer
	if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
		brew bundle install --file="$BREWFILE"
		log_ok "Homebrew packages installed"
	else
		log_info "Skipped. Run 'brew bundle install' manually later."
	fi
fi
