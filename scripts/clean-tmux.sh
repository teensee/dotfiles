#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/_lib.sh"

rm -rf "$HOME/.tmux/resurrect"/*
log_ok "tmux-resurrect snapshots removed"
