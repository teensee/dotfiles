SHELL := /bin/bash
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(HOME)/.dotfiles-backup-$(shell date +%Y%m%d-%H%M%S)

BACKUP_TARGETS := .zshrc .gitconfig .gitignore_global .tool-versions .ideavimrc Brewfile \
                  .config/nvim .config/fish .config/ghostty .config/tmux .config/htop \
                  .config/lazygit .config/tmuxinator

.PHONY: help install update backup restore clean check

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
	@echo "  check      - Show status of managed symlinks"
	@echo "  restore    - Restore from latest backup"
	@echo "  clean      - Clean temporary files"

# Full installation
install: backup
	@echo "[*] Installing dotfiles..."
	./install
	@echo "[+] Installation completed!"
	@echo "[!] Restart terminal to apply changes"

# Create backup of existing configs (skips when nothing to back up)
backup:
	@tmp_backup="$(BACKUP_DIR)"; \
	mkdir -p "$$tmp_backup"; \
	count=0; \
	for config in $(BACKUP_TARGETS); do \
		if [ -e "$(HOME)/$$config" ] || [ -L "$(HOME)/$$config" ]; then \
			dest_dir="$$tmp_backup/$$(dirname $$config)"; \
			mkdir -p "$$dest_dir"; \
			cp -RP "$(HOME)/$$config" "$$dest_dir/"; \
			count=$$((count+1)); \
			echo "    Backing up $$config"; \
		fi; \
	done; \
	if [ $$count -eq 0 ]; then \
		rmdir "$$tmp_backup" 2>/dev/null || true; \
		echo "[*] Nothing to back up"; \
	else \
		echo "[+] Backup created in $$tmp_backup ($$count items)"; \
	fi

# Update dotfiles
update: backup
	@echo "[*] Updating dotfiles..."
	git pull origin master
	git submodule update --init --recursive
	./install
	@echo "[+] Update completed!"

# Show status of managed symlinks
check:
	@echo "[*] Checking managed symlinks..."
	@for config in $(BACKUP_TARGETS); do \
		path="$(HOME)/$$config"; \
		if [ -L "$$path" ]; then \
			target="$$(readlink "$$path")"; \
			if [ -e "$$path" ]; then \
				echo "  OK     $$config -> $$target"; \
			else \
				echo "  BROKEN $$config -> $$target"; \
			fi; \
		elif [ -e "$$path" ]; then \
			echo "  FILE   $$config (not a symlink)"; \
		else \
			echo "  MISS   $$config"; \
		fi; \
	done

# Restore from latest backup
restore:
	@echo "[*] Looking for latest backup..."
	@latest="$$(ls -d $(HOME)/.dotfiles-backup-* 2>/dev/null | tail -1)"; \
	if [ -z "$$latest" ]; then \
		echo "[-] No backups found"; \
		exit 1; \
	fi; \
	echo "[*] Restoring from $$latest"; \
	cp -RP "$$latest"/. "$(HOME)"/; \
	echo "[+] Restore completed"

# Clean temporary files (caches only; tmux-resurrect snapshots preserved)
clean:
	@echo "[*] Cleaning caches..."
	@rm -f ~/.local/share/nvim/lazy-lock.json.bak
	@rm -rf ~/.cache/nvim
	@rm -f ~/.zcompdump*
	@echo "[+] Cleanup completed"
	@echo "[i] To wipe tmux-resurrect snapshots: make clean-tmux"

clean-tmux:
	@rm -rf ~/.tmux/resurrect/*
	@echo "[+] tmux-resurrect snapshots removed"

# Default target
.DEFAULT_GOAL := help
