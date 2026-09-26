#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_common.sh"

require_tools biome

log_info "Linting json/jsonc/js..."

# biome lint, а не check: check навязал бы своё форматирование и переписал
# zed/settings.json. Парсинг всё равно ловит невалидный JSON, отдельный jq не нужен.
biome lint .

log_ok "json OK"
