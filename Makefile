SHELL := /bin/bash
SCRIPTS := $(shell pwd)/scripts

.PHONY: help install update backup restore clean clean-tmux check

# Default target
.DEFAULT_GOAL := help

help:
	@$(SCRIPTS)/help.sh

# Full installation
install:
	@$(SCRIPTS)/backup.sh
	@echo "[*] Installing dotfiles..."
	./install
	@$(SCRIPTS)/brew.sh
	@echo "[+] Installation completed!"
	@echo "[!] Restart terminal to apply changes"

# Update dotfiles
update:
	@$(SCRIPTS)/backup.sh
	@echo "[*] Updating dotfiles..."
	git pull origin master
	git submodule update --init --recursive
	./install
	@$(SCRIPTS)/brew.sh
	@echo "[+] Update completed!"

backup:
	@$(SCRIPTS)/backup.sh

check:
	@$(SCRIPTS)/check.sh

restore:
	@$(SCRIPTS)/restore.sh

clean:
	@$(SCRIPTS)/clean.sh

clean-tmux:
	@$(SCRIPTS)/clean-tmux.sh
