#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_common.sh"

require_tools markdownlint prettier

log_info "Linting markdown..."

markdownlint .
prettier --check '**/*.md'

log_ok "markdown OK"
