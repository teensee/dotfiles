#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/../_lib.sh"

# Линтеры читают свои конфиги из корня репозитория
cd "$DOTFILES_DIR" || exit 1

# shellcheck disable=SC2034 # used by scripts sourcing this file
LINT_TOOLS=(shellcheck shfmt markdownlint prettier biome stylua)

# require_tools tool1 tool2 — упасть с подсказкой, если чего-то нет на PATH
require_tools() {
	local missing=()
	local tool
	for tool in "$@"; do
		command -v "$tool" >/dev/null 2>&1 || missing+=("$tool")
	done
	if [ ${#missing[@]} -gt 0 ]; then
		log_err "Missing tools: ${missing[*]}"
		log_hint "Run: brew bundle install --file=brew/Brewfile"
		exit 1
	fi
}

# Список файлов для shellcheck/shfmt: они не обходят дерево и требуют явных путей.
# Это выбор файлов, а не исключение — фильтрам здесь не место, область каждого
# линтера задаётся его собственным конфигом.
lint_shell_files() {
	git ls-files '*.sh' install
}
