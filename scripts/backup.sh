#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"
count=0

for config in "${TARGETS[@]}"; do
	src="$HOME/$config"
	if [ -e "$src" ] || [ -L "$src" ]; then
		dest_dir="$BACKUP_DIR/$(dirname "$config")"
		mkdir -p "$dest_dir"
		cp -RP "$src" "$dest_dir/"
		count=$((count + 1))
		log_item "Backing up $config"
	fi
done

if [ "$count" -eq 0 ]; then
	rmdir "$BACKUP_DIR" 2>/dev/null || true
	log_info "Nothing to back up"
else
	log_ok "Backup created in $BACKUP_DIR ($count items)"
fi
