#!/bin/bash

set -e

ZETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.zetup-backup-$(date +%Y%m%d-%H%M%S)"

echo "🚀 Zetup - Terminal Customization Setup"
echo "======================================="

check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "❌ This setup is designed for macOS only."
        exit 1
    fi
}

backup_existing_configs() {
    echo "📦 Backing up existing configurations..."
    mkdir -p "$BACKUP_DIR"
    
    [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$BACKUP_DIR/"
    [[ -f "$HOME/.tmux.conf" ]] && cp "$HOME/.tmux.conf" "$BACKUP_DIR/"
    [[ -d "$HOME/.tmux" ]] && cp -r "$HOME/.tmux" "$BACKUP_DIR/"
    
    echo "   Backup created at: $BACKUP_DIR"
}

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo "✅ Homebrew already installed"
    fi
}

install_dependencies() {
    echo "📦 Installing dependencies..."
    
    # Install Zsh if not present
    if ! command -v zsh &> /dev/null; then
        echo "   Installing Zsh..."
        brew install zsh
    else
        echo "   ✅ Zsh already installed"
    fi
    
    # Install Tmux if not present
    if ! command -v tmux &> /dev/null; then
        echo "   Installing Tmux..."
        brew install tmux
    else
        echo "   ✅ Tmux already installed"
    fi
    
    # Install Git if not present
    if ! command -v git &> /dev/null; then
        echo "   Installing Git..."
        brew install git
    else
        echo "   ✅ Git already installed"
    fi
}

install_antigen() {
    if [[ ! -f "$HOME/.antigen.zsh" ]]; then
        echo "🔗 Installing Antigen..."
        curl -L git.io/antigen > "$HOME/.antigen.zsh"
    else
        echo "✅ Antigen already installed"
    fi
}

install_tpm() {
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        echo "🔌 Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        echo "✅ TPM already installed"
    fi
}

link_configs() {
    echo "🔗 Linking configuration files..."
    
    # Link Zsh config
    ln -sf "$ZETUP_DIR/zsh/zshrc" "$HOME/.zshrc"
    
    # Link Tmux config
    ln -sf "$ZETUP_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    
    # Create aliases directory if it doesn't exist
    mkdir -p "$HOME/.config/zetup"
    ln -sf "$ZETUP_DIR/shared/aliases.zsh" "$HOME/.config/zetup/aliases.zsh"
}

set_zsh_as_default() {
    ZSH_PATH="$(which zsh)"
    
    if [[ "$SHELL" != "$ZSH_PATH" ]]; then
        echo "🐚 Setting Zsh as default shell..."
        
        # Check if Zsh is in allowed shells list
        if ! grep -q "^$ZSH_PATH$" /etc/shells; then
            echo "   Adding $ZSH_PATH to /etc/shells..."
            echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
        fi
        
        # Set as default shell
        chsh -s "$ZSH_PATH"
        echo "   Please restart your terminal or run 'exec zsh' to use the new shell"
    else
        echo "✅ Zsh is already the default shell"
    fi
}

install_tmux_plugins() {
    echo "🔌 Installing Tmux plugins..."
    if [[ -n "$TMUX" ]]; then
        # If inside tmux session, install plugins directly
        "$HOME/.tmux/plugins/tpm/bin/install_plugins"
    else
        # If not in tmux session, provide instructions
        echo "   TPM installed. To install plugins:"
        echo "   1. Start tmux: tmux"
        echo "   2. Press: Ctrl-b + Shift-i"
        echo "   Or run: tmux new-session -d && tmux send-keys 'tmux source ~/.tmux.conf' Enter && sleep 1 && ~/.tmux/plugins/tpm/bin/install_plugins && tmux kill-server"
    fi
}

main() {
    check_macos
    backup_existing_configs
    install_homebrew
    install_dependencies
    install_antigen
    install_tpm
    link_configs
    set_zsh_as_default
    install_tmux_plugins
    
    echo ""
    echo "🎉 Zetup installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run 'exec zsh'"
    echo "2. Run 'tmux' to start a new session"
    echo "3. Customize machine-specific settings in ~/.config/zetup/local.zsh"
    echo ""
    echo "Backup location: $BACKUP_DIR"
}

main "$@"