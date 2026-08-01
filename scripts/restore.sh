#!/usr/bin/env bash
set -euo pipefail

echo "[*] Looking for latest backup..."
latest="$(ls -d "$HOME/.dotfiles-backup-"* 2>/dev/null | tail -1)"

if [ -z "$latest" ]; then
    echo "[-] No backups found"
    exit 1
fi

echo "[*] Restoring from $latest"
cp -RP "$latest"/. "$HOME"/
echo "[+] Restore completed"
