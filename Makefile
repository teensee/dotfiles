SHELL := /bin/bash
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles-backup-$(shell date +%Y%m%d-%H%M%S)

.PHONY: help install update backup restore check clean

# Show help for available commands
help:
	@echo "Dotfiles Management"
	@echo ""
	@echo "Installation:"
	@echo "  install    - Full dotfiles installation"
	@echo "  backup     - Create backup of existing configs"
	@echo ""
	@echo "Updates:"
	@echo "  update     - Update dotfiles from repository"
	@echo ""
	@echo "Utilities:"
	@echo "  check      - Check configuration status"
	@echo "  restore    - Restore from latest backup"
	@echo "  clean      - Clean temporary files"

# Full installation
install: backup
	@echo "[*] Installing dotfiles..."
	./install
	@echo "[+] Installation completed!"
	@echo "[!] Restart terminal to apply changes"

# Create backup of existing configs
backup:
	@echo "[*] Creating backup in $(BACKUP_DIR)..."
	@mkdir -p $(BACKUP_DIR)
	@for config in .zshrc .gitconfig .tmux.conf .config/nvim .config/fish .config/ghostty; do \
		if [ -e "$(HOME)/$config" ]; then \
			echo "    Backing up $config"; \
			cp -r "$(HOME)/$config" "$(BACKUP_DIR)/"; \
		fi; \
	done
	@echo "[+] Backup created in $(BACKUP_DIR)"

# Update dotfiles
update: backup
	@echo "[*] Updating dotfiles..."
	git pull origin main
	git submodule update --init --recursive
	./install
	@echo "[+] Update completed!"

# Restore from latest backup
restore:
	@echo "[*] Looking for latest backup..."
	@LATEST_BACKUP=$(ls -d ~/.dotfiles-backup-* 2>/dev/null | tail -1); \
	if [ -z "$LATEST_BACKUP" ]; then \
		echo "[-] No backups found"; \
		exit 1; \
	fi; \
	echo "[*] Restoring from $LATEST_BACKUP"; \
	cp -r "$LATEST_BACKUP"/. ~/; \
	echo "[+] Restore completed"

# Clean temporary files
clean:
	@echo "[*] Cleaning temporary files..."
	@rm -rf ~/.local/share/nvim/lazy-lock.json.bak
	@rm -rf ~/.cache/nvim
	@rm -rf ~/.tmux/resurrect/*
	@rm -f ~/.zcompdump*
	@echo "[+] Cleanup completed"

# Default target
.DEFAULT_GOAL := help
