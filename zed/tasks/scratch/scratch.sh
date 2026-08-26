#!/usr/bin/env bash
set -euo pipefail

ext="$1"
template="${2:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
base="$HOME/Programming/scratches"

# Go: каждый скретч — изолированный модуль
if [ "$ext" = "go" ]; then
	go_dir="$base/go"
	mkdir -p "$go_dir"

	n=1
	while [ -d "$go_dir/scratch_$n" ]; do
		n=$((n + 1))
	done

	scratch_dir="$go_dir/scratch_$n"
	mkdir -p "$scratch_dir"
	cp "$SCRIPT_DIR/_templates/go.tpl" "$scratch_dir/main.go"
	(cd "$scratch_dir" && go mod init "scratch_$n")

	zed "$scratch_dir/main.go"
	exit 0
fi

# Остальные языки: плоский файл scratch_N.<ext>
mkdir -p "$base"

n=1
while [ -e "$base/scratch_$n.$ext" ]; do
	n=$((n + 1))
done

f="$base/scratch_$n.$ext"

if [ -n "$template" ] && [ -f "$SCRIPT_DIR/_templates/$template" ]; then
	cp "$SCRIPT_DIR/_templates/$template" "$f"
else
	: >"$f"
fi

[ "$ext" = "sh" ] && chmod +x "$f"

zed "$f"
