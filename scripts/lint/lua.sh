#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_common.sh"

require_tools stylua

log_info "Linting lua..."

# stylua сам находит nvim/.stylua.toml по каталогу проверяемого файла
stylua --check .

log_ok "lua OK"
