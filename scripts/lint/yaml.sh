#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_common.sh"

require_tools prettier

log_info "Linting yaml..."

prettier --check '**/*.{yaml,yml}'

log_ok "yaml OK"
