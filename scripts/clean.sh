#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

log_info "Cleaning caches..."
rm -f "$HOME/.local/share/nvim/lazy-lock.json.bak"
rm -rf "$HOME/.cache/nvim"
rm -f "$HOME"/.zcompdump*
log_ok "Cleanup completed"
log_hint "To wipe tmux-resurrect snapshots: make clean-tmux"
