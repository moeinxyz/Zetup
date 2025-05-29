# Zetup 🚀

A comprehensive terminal customization system for macOS that provides a modular, user-agnostic, and self-installing setup for Zsh and Tmux.

## Features

- ✅ **Automated Installation**: One-command setup for all dependencies
- ⚙️ **Zsh Configuration**: Powered by Antigen with oh-my-zsh plugins
- 🖥️ **Tmux Configuration**: TPM-managed plugins with sensible defaults
- 📦 **Dependency Management**: Automatic installation of required tools
- 🔁 **Reusable**: Works on any macOS system without modification
- 🧑‍💻 **User-Agnostic**: No hardcoded paths or usernames
- 🧩 **Modular**: Shared configs with machine-specific overrides
- 📁 **Centralized Aliases**: Comprehensive alias collection
- 🧽 **Clean & Idempotent**: Safe to run multiple times

## Quick Start

```bash
git clone https://github.com/yourusername/zetup.git
cd zetup
./install.sh
```

## What Gets Installed

### Dependencies (via Homebrew)
- **Zsh**: Modern shell with extensive plugin ecosystem
- **Tmux**: Terminal multiplexer for session management
- **Git**: Version control system
- **Antigen**: Zsh plugin manager
- **TPM**: Tmux Plugin Manager

### Zsh Configuration
- **Theme**: robbyrussell (oh-my-zsh)
- **Plugins**:
  - `git` - Git aliases and functions
  - `pip` - Python package manager shortcuts
  - `sdk` - SDKMAN integration
  - `lein` - Leiningen support
  - `command-not-found` - Suggests package installations
  - `zsh-users/zsh-completions` - Additional completions
  - `zsh-users/zsh-syntax-highlighting` - Command syntax highlighting

### Tmux Configuration
- **Plugins**:
  - `tmux-plugins/tpm` - Plugin manager
  - `tmux-plugins/tmux-sensible` - Sensible defaults
  - `wfxr/tmux-power` - Beautiful powerline theme
- **Features**:
  - Mouse support enabled
  - Vi-mode key bindings
  - Intuitive pane splitting (`|` and `-`)
  - Smart pane navigation
  - Enhanced status bar

## Directory Structure

```
zetup/
├── install.sh              # Main installation script
├── zsh/
│   └── zshrc               # Zsh configuration
├── tmux/
│   └── tmux.conf           # Tmux configuration
├── shared/
│   └── aliases.zsh         # Centralized aliases
├── examples/
│   ├── local.zsh.example           # Machine-specific Zsh config template
│   ├── tmux.local.conf.example     # Machine-specific Tmux config template
│   └── aliases.local.zsh.example   # Machine-specific aliases template
└── README.md
```

## Customization

### Machine-Specific Configuration

Create local override files in `~/.config/zetup/`:

1. **Zsh Overrides**: `~/.config/zetup/local.zsh`
   ```bash
   cp examples/local.zsh.example ~/.config/zetup/local.zsh
   # Edit with your machine-specific settings
   ```

2. **Tmux Overrides**: `~/.config/zetup/tmux.local.conf`
   ```bash
   cp examples/tmux.local.conf.example ~/.config/zetup/tmux.local.conf
   # Add your custom tmux settings
   ```

3. **Local Aliases**: `~/.config/zetup/aliases.local.zsh`
   ```bash
   cp examples/aliases.local.zsh.example ~/.config/zetup/aliases.local.zsh
   # Add machine-specific aliases
   ```

### Global User Customization

- **Zsh**: `~/.zshrc.local` - Additional user customizations
- **Tmux**: Machine-specific configs are loaded via the local.conf mechanism

## Included Aliases

### Navigation
- `..`, `...`, `....` - Quick directory traversal
- `~`, `-` - Home and previous directory

### Git Shortcuts
- `g`, `ga`, `gc`, `gp`, `gl` - Common git commands
- `gco`, `gb`, `gd` - Checkout, branch, diff
- `gs`, `gss` - Status (detailed and short)

### Docker & Kubernetes
- `d`, `dc` - Docker and docker-compose
- `k`, `kgp`, `kgs` - Kubectl shortcuts

### Development
- `py`, `pip` - Python shortcuts
- `ni`, `nr`, `ns` - npm shortcuts
- `y`, `ya`, `yr` - Yarn shortcuts

### System Utilities
- `ll`, `la`, `lt` - Enhanced ls variants
- `df`, `du` - Disk usage with human-readable output
- `myip`, `localip` - IP address discovery

[View complete alias list](shared/aliases.zsh)

## Advanced Usage

### Manual Plugin Installation

If you need to install tmux plugins manually:
```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

### Reloading Configurations

- **Zsh**: `exec zsh` or restart terminal
- **Tmux**: `tmux source ~/.tmux.conf` or `prefix + r`

### Backup and Restore

The installer automatically creates backups in `~/.zetup-backup-TIMESTAMP/`. To restore:
```bash
cp ~/.zetup-backup-*/zshrc ~/.zshrc
cp ~/.zetup-backup-*/tmux.conf ~/.tmux.conf
```

## Troubleshooting

### Common Issues

1. **Antigen not loading**: Ensure `~/.antigen.zsh` exists and is sourced
2. **Tmux plugins not working**: Run TPM installer manually
3. **Zsh not default shell**: Run `chsh -s $(which zsh)`
4. **Permission denied**: Ensure `install.sh` is executable (`chmod +x install.sh`)

### Homebrew Issues

If Homebrew isn't in PATH after installation:
```bash
# Intel Macs
eval "$(/usr/local/bin/brew shellenv)"

# Apple Silicon Macs
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Requirements

- **macOS**: 10.15+ (Catalina or later)
- **Internet Connection**: For downloading dependencies
- **Administrator Access**: For Homebrew installation (if not present)

## Uninstallation

To remove Zetup configurations:

```bash
# Restore original configs (if backed up)
cp ~/.zetup-backup-*/zshrc ~/.zshrc
cp ~/.zetup-backup-*/tmux.conf ~/.tmux.conf

# Or remove Zetup configs
rm ~/.zshrc ~/.tmux.conf
rm -rf ~/.config/zetup
rm -rf ~/.tmux/plugins
rm ~/.antigen.zsh

# Reset shell to default
chsh -s /bin/zsh
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [oh-my-zsh](https://ohmyz.sh/) - Framework for managing Zsh configuration
- [Antigen](https://github.com/zsh-users/antigen) - Plugin manager for Zsh
- [TPM](https://github.com/tmux-plugins/tpm) - Tmux Plugin Manager
- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) - Sensible tmux defaults