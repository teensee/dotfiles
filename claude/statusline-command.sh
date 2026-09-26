#!/bin/bash
# Claude Code statusLine — based on oh-my-zsh bureau theme

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Time
time_str=$(date +%H:%M:%S)

# Git branch and status (skip optional locks to avoid blocking)
git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
	branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null ||
		git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
	if [ -n "$branch" ]; then
		gitstatus=$(git -C "$cwd" status --porcelain -b --no-lock-index 2>/dev/null)
		status_icons=""

		# Staged changes
		if echo "$gitstatus" | tail -n +2 | grep -qE '^[AMRD]. '; then
			status_icons="${status_icons}●" # staged (green in real theme)
		fi
		# Unstaged changes
		if echo "$gitstatus" | tail -n +2 | grep -qE '^.[MTD] '; then
			status_icons="${status_icons}●" # unstaged (yellow in real theme)
		fi
		# Untracked files
		if echo "$gitstatus" | tail -n +2 | grep -qE '^\?\? '; then
			status_icons="${status_icons}●" # untracked (red in real theme)
		fi
		# Clean
		if [ -z "$status_icons" ]; then
			status_icons="✓"
		fi
		# Ahead/behind
		if echo "$gitstatus" | head -1 | grep -q 'ahead'; then
			status_icons="${status_icons}▴"
		fi
		if echo "$gitstatus" | head -1 | grep -q 'behind'; then
			status_icons="${status_icons}▾"
		fi

		git_info=" [±${branch} ${status_icons}]"
	fi
fi

# Context usage suffix
ctx_suffix=""
if [ -n "$used" ]; then
	ctx_suffix=" [ctx: ${used}%]"
fi

# Model suffix
model_suffix=""
if [ -n "$model" ]; then
	model_suffix=" [${model}]"
fi

printf "[%s]\n%s\n%s%s" \
	"$time_str" "${git_info# }" "${model_suffix# }" "$ctx_suffix"
