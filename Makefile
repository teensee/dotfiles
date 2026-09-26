SHELL := /bin/bash
SCRIPTS := $(shell pwd)/scripts

.PHONY: help install update backup restore clean clean-tmux check \
	lint lint-deps lint-sh lint-md lint-json lint-lua lint-yaml

# Default target
.DEFAULT_GOAL := help

help:
	@$(SCRIPTS)/help.sh

# Full installation
install:
	@$(SCRIPTS)/backup.sh
	@echo "[*] Installing dotfiles..."
	./install
	@$(SCRIPTS)/install-omz.sh
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
	@$(SCRIPTS)/install-omz.sh
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

# Linting
#
# Вся механика — в scripts/lint/*.sh; область каждого линтера задана его собственным
# конфигом (.prettierignore, .markdownlintignore, biome.json, .styluaignore), поэтому
# прямой запуск инструмента из консоли даёт тот же результат, что make.
lint:
	@$(SCRIPTS)/lint/all.sh

lint-deps:
	@$(SCRIPTS)/lint/deps.sh

lint-sh:
	@$(SCRIPTS)/lint/sh.sh

lint-md:
	@$(SCRIPTS)/lint/md.sh

lint-json:
	@$(SCRIPTS)/lint/json.sh

lint-lua:
	@$(SCRIPTS)/lint/lua.sh

lint-yaml:
	@$(SCRIPTS)/lint/yaml.sh
