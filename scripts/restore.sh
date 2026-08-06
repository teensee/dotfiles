#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

log_info "Looking for latest backup..."
latest="$(ls -d "$HOME/.dotfiles-backup-"* 2>/dev/null | tail -1)"

if [ -z "$latest" ]; then
	log_err "No backups found"
	exit 1
fi

log_info "Backup contents:"
find "$latest" -not -type d | sed "s|^$latest/|    |" | sort

printf "\nRestore from %s? [y/N] " "$latest"
read -r answer
if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
	log_info "Restore cancelled"
	exit 0
fi

log_info "Restoring from $latest"
cp -RP "$latest"/. "$HOME"/
log_ok "Restore completed"
