#!/usr/bin/env bash
set -euo pipefail

printf "Dotfiles Management\n\n"

printf "Installation:\n"
printf "  %-11s  %s\n" "install" "Full dotfiles installation"
printf "  %-11s  %s\n" "backup" "Create backup of existing configs"
printf "\n"

printf "Updates:\n"
printf "  %-11s  %s\n" "update" "Update dotfiles from repository"
printf "\n"

printf "Utilities:\n"
printf "  %-11s  %s\n" "check" "Show status of managed symlinks"
printf "  %-11s  %s\n" "restore" "Restore from latest backup"
printf "  %-11s  %s\n" "clean" "Clean temporary files"
printf "  %-11s  %s\n" "clean-tmux" "Wipe tmux-resurrect snapshots"
