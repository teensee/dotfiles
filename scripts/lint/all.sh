#!/usr/bin/env bash
set -uo pipefail

source "$(dirname "$0")/_common.sh"

lint_dir="$(dirname "$0")"
failed=()

for target in sh md json lua yaml; do
	"$lint_dir/$target.sh" || failed+=("$target")
	echo
done

if [ ${#failed[@]} -gt 0 ]; then
	log_err "Failed: ${failed[*]}"
	exit 1
fi

log_ok "All linters passed"
