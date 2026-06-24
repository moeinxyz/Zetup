# Zetup 🚀

A comprehensive terminal customization system for macOS that provides a modular, user-agnostic, and self-installing setup for Zsh and Tmux.

## Features

- ✅ **Automated Installation**: One-command setup for all dependencies
- ⚙️ **Zsh Configuration**: Powered by Antigen with oh-my-zsh plugins
- 🖥️ **Tmux Configuration**: TPM-managed plugins with sensible defaults
- 🔔 **AI Attention Signals**: Tmux window markers for Codex/Claude panes that need input
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
  - **iTerm-native text selection** - Works exactly like without tmux
  - Vi-mode key bindings
  - Intuitive pane splitting (`|` and `-`)
  - Smart pane navigation
  - Enhanced status bar
  - **System clipboard integration** - Copy to macOS clipboard
  - **Keyboard copy mode** - Advanced selection for power users

## Directory Structure

```
zetup/
├── install.sh              # Main installation script
├── zsh/
│   └── zshrc.local.template # Template for local ~/.zshrc
├── tmux/
│   └── tmux.conf           # Tmux configuration
├── shared/
│   ├── shared.zsh          # Main Zsh configuration (sourced by local ~/.zshrc)
│   ├── attention.zsh       # Manual tmux attention commands for AI CLIs
│   ├── aliases.zsh         # Centralized aliases
│   ├── ai-assistant.zsh    # AI terminal assistant
│   └── ai-helpers/         # AI helper scripts
├── examples/
│   ├── local.zsh.example           # Machine-specific Zsh config template
│   ├── tmux.local.conf.example     # Machine-specific Tmux config template
│   └── aliases.local.zsh.example   # Machine-specific aliases template
└── README.md
```

## Customization

### Machine-Specific Configuration

Zetup creates a **local** `~/.zshrc` file that sources the shared configuration. This means:

- ✅ **Tools can safely modify `~/.zshrc`** without affecting the shared config
- ✅ **Machine-specific paths stay local** and aren't committed to git
- ✅ **Shared configuration stays clean** and portable

#### Adding Machine-Specific Settings

1. **Direct in `~/.zshrc`**: Add paths, aliases, and settings directly to your local `~/.zshrc`
   ```bash
   # Machine-specific PATH additions
   export PATH="$HOME/custom-tools:$PATH"

   # Machine-specific aliases
   alias myserver='ssh user@myserver.com'
   ```

2. **Zsh Overrides**: `~/.config/zetup/local.zsh` (optional)
   ```bash
   cp examples/local.zsh.example ~/.config/zetup/local.zsh
   # Edit with your machine-specific settings
   ```

3. **Tmux Overrides**: `~/.config/zetup/tmux.local.conf`
   ```bash
   cp examples/tmux.local.conf.example ~/.config/zetup/tmux.local.conf
   # Add your custom tmux settings
   ```

4. **Local Aliases**: `~/.config/zetup/aliases.local.zsh` (optional)
   ```bash
   cp examples/aliases.local.zsh.example ~/.config/zetup/aliases.local.zsh
   # Add machine-specific aliases
   ```

### Global User Customization

- **Zsh**: `~/.zshrc.local` - Additional user customizations (loaded automatically)
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

### AI Attention Signals

When Codex or Claude needs input inside tmux, Zetup shows a colored blinking `●` icon in the tmux window status. The marker stays visible when you switch to that window. It clears from lifecycle events when the tool resumes work or the session ends, and `prefix + A` clears it manually.

For unsupported tools, Zetup no longer watches terminal output because that caused false positives. Mark or clear attention manually:

```bash
attn mark some-ai-cli input-needed
attn complete some-ai-cli
attn clear
```

The installer adds Codex and Claude lifecycle hooks so approval/input and turn-complete events can mark the window reliably. Codex also uses its official notify event stream; if you already had a Codex notifier configured, Zetup chains it after marking tmux state. If Codex asks you to review new hooks, open `/hooks` and trust the Zetup attention hooks.

Environment switches:
- `ZETUP_ATTENTION=0` disables attention marking.
- `ZETUP_ATTENTION_INSTALL_HOOKS=0 ./install.sh` skips hook installation.

### Tmux Copy/Paste Guide

The tmux configuration is designed to work seamlessly with iTerm's native text selection:

#### Mouse Selection (Recommended)
1. **Click and drag** to select text - works exactly like in iTerm without tmux
2. **Copy selection**: `Cmd+C` or right-click → Copy
3. **Paste**: `Cmd+V` in any application

#### Keyboard Selection (tmux copy mode)
1. **Enter copy mode**: `prefix + [` (or `Ctrl+b [`)
2. **Start selection**: Press `v` to begin selection
3. **Move cursor**: Use arrow keys or vi keys (`h`, `j`, `k`, `l`)
4. **Copy selection**: Press `y` - text is copied to system clipboard
5. **Exit copy mode**: Automatically exits after copying

#### Quick Copy Options
- **Double-click** on a word to copy it (iTerm native)
- **Triple-click** to copy entire line (iTerm native)

#### Pasting
- **From tmux buffer**: `prefix + ]`
- **From system clipboard**: `Cmd+V` (works in most terminals)

#### Why This Approach?
- **Natural feel**: Text selection works exactly like in iTerm without tmux
- **No conflicts**: tmux doesn't interfere with iTerm's native selection
- **Familiar workflow**: Use `Cmd+C`/`Cmd+V` as you normally would
- **Fallback option**: tmux copy mode available for advanced users

### Tmux Key Bindings

#### **Prefix Key**: `Ctrl+b` (default)

---

#### **Essential Bindings**

**Pane Management**
- `prefix + |` - Split pane horizontally
- `prefix + -` - Split pane vertically  
- `prefix + h/j/k/l` - Navigate between panes (vim-style)
- `prefix + H/J/K/L` - Resize panes (5 units at a time)
- `prefix + z` - Toggle pane zoom
- `prefix + x` - Kill current pane

**Window Management**
- `prefix + c` - Create new window
- `prefix + n` - Next window
- `prefix + p` - Previous window
- `prefix + 0-9` - Switch to window by number
- `prefix + ,` - Rename current window
- `prefix + &` - Kill current window

**Copy/Paste**
- `prefix + [` - Enter copy mode
- `prefix + ]` - Paste from tmux buffer
- **In copy mode**: `v` to select, `y` to copy to clipboard

---

#### **No-Prefix Bindings (Alt/Arrow)**

**Pane Navigation** (No prefix needed!)
- `Alt + ↑` - Select pane above
- `Alt + ↓` - Select pane below  
- `Alt + ←` - Select pane left
- `Alt + →` - Select pane right

---

#### **Utility Bindings**

**Session Management**
- `prefix + d` - Detach from session
- `prefix + s` - List sessions
- `prefix + $` - Rename session

**Configuration**
- `prefix + r` - Reload tmux config
- `prefix + ?` - Show all key bindings
- `prefix + A` - Clear the current AI attention marker

**Layout Management**
- `prefix + Space` - Next layout
- `prefix + M-1` - Even horizontal layout
- `prefix + M-2` - Even vertical layout
- `prefix + M-3` - Main horizontal layout
- `prefix + M-4` - Main vertical layout
- `prefix + M-5` - Tiled layout

---

#### **Copy Mode (Advanced)**

When in copy mode (`prefix + [`):
- `v` - Start selection
- `y` - Copy selection to clipboard
- `h/j/k/l` - Move cursor
- `Ctrl+u/Ctrl+d` - Page up/down
- `g/G` - Go to top/bottom
- `?/` - Search backward/forward
- `n/N` - Next/previous search result
- `q` - Quit copy mode

---

#### **Pro Tips**

1. **Most Used**: `Alt + arrows` for pane navigation (no prefix!)
2. **Quick Splits**: `prefix + |` and `prefix + -` for new panes
3. **Vim Navigation**: `prefix + h/j/k/l` for pane switching
4. **Text Selection**: Use iTerm's native selection (mouse drag + `Cmd+C`)
5. **Config Reload**: `prefix + r` after making changes

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

### Tmux Copy/Paste Issues

1. **Text not copying to clipboard**: Ensure `pbcopy` is available (`which pbcopy`)
2. **Mouse selection not working**: Check if mouse mode is enabled (`tmux show -g mouse`)
3. **Copy mode not responding**: Try reloading config (`prefix + r`)
4. **Clipboard integration broken**: Restart tmux server (`tmux kill-server`)

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
