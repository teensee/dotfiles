#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_common.sh"

require_tools "${LINT_TOOLS[@]}"

log_ok "All lint tools present: ${LINT_TOOLS[*]}"
