# Shell

## Zsh (`zsh/`)

Oh-My-Zsh + bureau theme (`ZSH_THEME="bureau"`). Auto-update every 7 days.

### PATH

homebrew (`/opt/homebrew/bin` + `sbin`), bison, go, `~/.local/bin` (codegraph), asdf shims.

### OMZ plugins

`git`, `docker`, `docker-compose`, `macos`, `composer`, `kubectl`, `history`, `zsh-autosuggestions`, `dotenv`, `gpg-agent`, `keychain`.

`compinit` cached — rebuilds once per day (compares day-of-year of `~/.zcompdump`).

### Aliases

| Alias     | Target                                 |
| --------- | -------------------------------------- |
| `mux`     | `tmuxinator`                           |
| `nvnotes` | `cd ~/Library/.../ObsidianNotes; nvim` |
| `cat`     | `bat`                                  |
| `ls`      | `eza` (icons, colors, git status)      |
| `ll`      | `eza -alF` (detailed list)             |
| `la`      | `eza -a` (incl. hidden)                |
| `lt`      | `eza --tree` (tree view)               |

### Brew helpers

- `brewadd <pkg>` — `brew bundle add --install` → Brewfile
- `brewup` — `brew update && upgrade -y && brew bundle dump --force && autoremove`

### Integrations

- **fzf** — key bindings + fuzzy completion; default command via `fd --type f --hidden --follow --exclude .git`
- **zoxide** — smart `cd` (`z` command); init via `eval "$(zoxide init zsh)"`
- **zsh-syntax-highlighting** — sourced last (via homebrew path)

### External sources

Docker init (`~/.docker/init-zsh.sh`), ngrok completion (if installed), JetBrains vmoptions (`~/.jetbrains.vmoptions.sh`).

## Fish (`fish/`)

- `config.fish` — main config
- `completions/` — custom completions
- `conf.d/` — config snippets
- `functions/` — custom functions

## Tmuxinator (`tmuxinator/`)

Project-specific tmux session templates. Launched via `mux <project>` (zsh alias).
