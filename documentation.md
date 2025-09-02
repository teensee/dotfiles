# Dotfiles Documentation

## System Requirements

- macOS 12+
- Git
- Internet connection for initial setup

## Directory Structure

```
dotfiles/
├── nvim/              # Neovim configuration (NvChad based)
├── zsh/               # Zsh shell configuration
├── fish/              # Fish shell configuration
├── tmux/              # Tmux configuration
├── git/               # Git configurations
├── ghostty/           # Ghostty terminal settings
├── lazygit/           # LazyGit UI configuration
├── brew/              # Homebrew packages list
├── tmuxinator/        # Tmux project templates
├── vim/               # IdeaVim configuration
├── htop/              # System monitor configuration
└── install.conf.yaml  # Dotbot installation script
```

## Tools Overview

### Editors & IDEs

#### Neovim
- **Base**: NvChad framework
- **Languages**: Go, PHP, Python, JavaScript, TypeScript
- **Features**: 
  - LSP integration (gopls, phpactor, pyright)
  - GitHub Copilot
  - Database UI
  - File tree navigation
  - Integrated terminal

#### IdeaVim
- Vim emulation for JetBrains IDEs
- Custom key mappings for productivity
- Integration with IDE features

### Shell & Terminal

#### Zsh
- **Framework**: Oh-My-Zsh
- **Theme**: Bureau
- **Plugins**: 
  - git, docker, docker-compose
  - kubectl, composer
  - zsh-autosuggestions
- **Features**: Smart history, auto-completion

#### Fish Shell
- Alternative shell with built-in autosuggestions
- Custom completions for Docker, Kubernetes
- Clean syntax highlighting

#### Tmux
- **Theme**: Dracula
- **Features**:
  - Session persistence
  - Vim-like navigation
  - Status bar with system info
  - Plugin manager (TPM)

#### Ghostty Terminal
- Modern GPU-accelerated terminal
- Custom font and theme configuration

### Development Tools

#### Git
- Global configuration with aliases
- Conditional configs for different projects
- Integration with work/personal environments
- Custom ignore patterns

#### Docker & Kubernetes
- Shell completions
- Aliases for common operations
- Integration with development workflow

#### Database Tools
- Database UI in Neovim
- Connection management
- Query execution and results viewing

### Productivity Tools

#### Tmuxinator
- Project-specific tmux session templates
- Automated environment setup
- Quick project switching

#### LazyGit
- Terminal UI for Git operations
- Custom theme configuration
- Keyboard shortcuts

#### htop
- System resource monitoring
- Custom display configuration
- Color scheme optimization

## Configuration Details

### Neovim Plugins

Core plugins include:
- **NvChad**: Base configuration framework
- **Mason**: LSP server management
- **Telescope**: Fuzzy finder
- **Treesitter**: Syntax highlighting
- **Gitsigns**: Git integration
- **Which-key**: Keybinding help

Development plugins:
- **go.nvim**: Go development tools
- **phpactor**: PHP language server
- **copilot.lua**: AI code completion
- **blink.cmp**: Completion engine

### Shell Configurations

#### Zsh aliases and functions:
- `mux` - tmuxinator shortcut
- `nvnotes` - Open Obsidian notes in Neovim
- Docker and Git shortcuts

#### Fish completions:
- Docker containers and images
- Kubernetes resources
- Custom command completions

### Git Workflow

The configuration supports multiple Git identities:
- Personal projects: `~/.gitconfig-local`
- Work projects: `~/.gitconfig-work`
- Conditional inclusion based on directory

### Tmux Sessions

Predefined project templates:
- Development environments
- Docker container management
- Database administration
- System monitoring

## Customization Guide

### Adding New Tools

1. Install via Homebrew (add to `brew/Brewfile`)
2. Add configuration files to appropriate directory
3. Update `install.conf.yaml` for symlinking
4. Document in this file

### Modifying Keybindings

#### Neovim
Edit `nvim/lua/mappings.lua` for global bindings
Language-specific bindings in respective plugin configs

#### Tmux
Modify `tmux/tmux.conf` for session management
Plugin settings in the same file

#### Shell
Add aliases to `zsh/zshrc` or `fish/config.fish`

### Theme Customization

Most tools use consistent themes:
- **Neovim**: Catppuccin/OneDark
- **Tmux**: Dracula
- **Terminal**: Dracula-compatible

## Troubleshooting

### Common Issues

#### Neovim plugins not loading
```bash
# Reinstall plugins
nvim --headless "+Lazy! sync" +qa

# Clear cache
rm -rf ~/.cache/nvim
rm -rf ~/.local/share/nvim
```

#### Tmux plugins not working
```bash
# Reinstall TPM
rm -rf ~/.config/tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Install plugins: Prefix + I
```

#### Shell completions missing
```bash
# Zsh
rm ~/.zcompdump*
exec zsh

# Fish
fish -c "fish_update_completions"
```

#### Git configuration issues
```bash
# Check current config
git config --list --show-origin

# Verify includes are working
git config --get user.name
git config --get user.email
```

### Performance Issues

#### Slow shell startup
- Check plugin loading in shell config
- Profile startup with `time zsh -i -c exit`
- Disable unnecessary plugins

#### Neovim lag
- Update plugins: `:Lazy sync`
- Check LSP status: `:LspInfo`
- Disable unused language servers

### Recovery

#### Restore from backup
```bash
# Find latest backup
ls ~/.dotfiles-backups/

# Use restore script
~/.dotfiles-backups/backup-YYYYMMDD-HHMMSS/restore.sh
```

#### Reset to defaults
```bash
# Remove all configs
rm -rf ~/.config/nvim ~/.tmux.conf ~/.zshrc

# Reinstall
cd ~/.dotfiles
make install
```

## Advanced Usage

### Custom Project Templates

Create new tmuxinator templates:
```bash
# Generate template
tmuxinator new project_name

# Edit template
tmuxinator edit project_name

# Start session
tmuxinator start project_name
```

### Database Connections

Configure database connections in Neovim:
1. Open database UI: `<leader>db`
2. Add connection details
3. Save queries in project directory

### Docker Integration

Common workflows:
- Container management via lazydocker
- Shell completions for container names
- Project-specific compose configurations

## Security Considerations

### Sensitive Data

- Never commit actual credentials
- Use example files for templates
- Leverage system keychain for secrets
- Separate work/personal configurations

### SSH Configuration

- Keep SSH keys out of dotfiles
- Only sync SSH config file
- Use separate configs for different environments

### GPG Integration

- Configure Git signing
- Manage keys separately
- Set up proper agent forwarding
