#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

echo "[*] Checking managed symlinks..."

for config in "${TARGETS[@]}"; do
	path="$HOME/$config"
	if [ -L "$path" ]; then
		target="$(readlink "$path")"
		if [ -e "$path" ]; then
			echo "  OK     $config -> $target"
		else
			echo "  BROKEN $config -> $target"
		fi
	elif [ -e "$path" ]; then
		echo "  FILE   $config (not a symlink)"
	else
		echo "  MISS   $config"
	fi
done
