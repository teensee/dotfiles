#!/usr/bin/env bash
set -euo pipefail

echo "[*] Cleaning caches..."
rm -f ~/.local/share/nvim/lazy-lock.json.bak
rm -rf ~/.cache/nvim
rm -rf ~/.zcompdump*
echo "[+] Cleanup completed"
echo "[i] To wipe tmux-resurrect snapshots: make clean-tmux"
