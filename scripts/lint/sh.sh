#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_common.sh"

require_tools shellcheck shfmt

log_info "Linting shell scripts..."

# read-loop, а не mapfile: системный bash на macOS — 3.2
files=()
while IFS= read -r file; do
	files+=("$file")
done < <(lint_shell_files)

shellcheck "${files[@]}"
shfmt -d "${files[@]}"

log_ok "shell OK"
