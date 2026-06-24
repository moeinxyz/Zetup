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

    # Install Nerd Fonts for better icon support
    if ! brew list --cask font-fira-code-nerd-font &> /dev/null; then
        echo "   Installing FiraCode Nerd Font for icon support..."
        brew install --cask font-fira-code-nerd-font
    else
        echo "   ✅ FiraCode Nerd Font already installed"
    fi

    if ! brew list --cask font-jetbrains-mono-nerd-font &> /dev/null; then
        echo "   Installing JetBrains Mono Nerd Font for icon support..."
        brew install --cask font-jetbrains-mono-nerd-font
    else
        echo "   ✅ JetBrains Mono Nerd Font already installed"
    fi

    if ! brew list --cask font-meslo-lg-nerd-font &> /dev/null; then
        echo "   Installing Meslo LG Nerd Font for icon support..."
        brew install --cask font-meslo-lg-nerd-font
    else
        echo "   ✅ Meslo LG Nerd Font already installed"
    fi
}

install_ai_assistant() {
    echo "🤖 Installing AI Terminal Assistant..."
    
    # Install Ollama if not present
    if ! brew list ollama &> /dev/null; then
        echo "   Installing Ollama..."
        brew install ollama
    else
        echo "   ✅ Ollama already installed"
    fi
    
    # Install pipx if not present
    if ! command -v pipx &> /dev/null; then
        echo "   Installing pipx..."
        brew install pipx
        pipx ensurepath
    else
        echo "   ✅ pipx already installed"
    fi
    
    # Install LLM CLI tool
    if ! command -v llm &> /dev/null; then
        echo "   Installing LLM CLI tool..."
        pipx install llm
    else
        echo "   ✅ LLM CLI already installed"
    fi
    
    # Start Ollama service
    echo "   Starting Ollama service..."
    if brew list ollama &> /dev/null; then
        if brew services start ollama &> /dev/null; then
            echo "   ✅ Ollama service started"
        else
            echo "   ⚠️  Ollama service start failed (this is often harmless)"
            echo "   You can manually start it later with: brew services start ollama"
        fi
    else
        echo "   ❌ Ollama not installed, skipping service start"
        return 1
    fi
    
    # Pull a suitable local model (CodeLlama for command generation)
    echo "   Pulling CodeLlama model (this may take a few minutes)..."
    ollama pull codellama:7b-instruct
    
    # Configure LLM to use Ollama
    echo "   Configuring LLM to use local Ollama..."
    pipx inject llm llm-ollama
    
    # Create AI assistant config directory
    mkdir -p "$HOME/.config/zetup/ai"
    
    echo "   ✅ AI Terminal Assistant setup complete"
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
    # Remove any existing symlinks or installations
    if [[ -L "$HOME/.tmux/plugins/tpm" ]]; then
        echo "🔄 Removing old TPM symlink..."
        rm "$HOME/.tmux/plugins/tpm"
    fi

    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        echo "🔌 Installing TPM (Tmux Plugin Manager)..."
        mkdir -p "$HOME/.tmux/plugins"
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        echo "✅ TPM already installed"
    fi
}

link_configs() {
    echo "🔗 Setting up configuration files..."

    # Create zetup config directory
    mkdir -p "$HOME/.config/zetup"

    # Link shared Zsh config
    ln -sf "$ZETUP_DIR/shared/shared.zsh" "$HOME/.config/zetup/shared.zsh"

    # Create local ~/.zshrc from template (not a symlink)
    if [[ ! -f "$HOME/.zshrc" ]]; then
        cp "$ZETUP_DIR/zsh/zshrc.local.template" "$HOME/.zshrc"
        echo "   Created local ~/.zshrc (tools can modify this without affecting shared config)"
    else
        echo "   ⚠️  ~/.zshrc already exists, not overwriting. You may need to manually add:"
        echo "      source \"\$HOME/.config/zetup/shared.zsh\""
    fi

    # Link Tmux config
    ln -sf "$ZETUP_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Link shared aliases
    ln -sf "$ZETUP_DIR/shared/aliases.zsh" "$HOME/.config/zetup/aliases.zsh"

    # Link tmux attention integration
    ln -sf "$ZETUP_DIR/shared/attention.zsh" "$HOME/.config/zetup/attention.zsh"

    # Link AI assistant
    ln -sf "$ZETUP_DIR/shared/ai-assistant.zsh" "$HOME/.config/zetup/ai-assistant.zsh"

    # Link AI helper scripts
    ln -sf "$ZETUP_DIR/shared/ai-helpers" "$HOME/.config/zetup/ai-helpers"
}

install_attention_hooks() {
    echo "🔔 Installing tmux attention integration..."

    if [[ "${ZETUP_ATTENTION_INSTALL_HOOKS:-1}" == "0" ]]; then
        echo "   Skipped hooks because ZETUP_ATTENTION_INSTALL_HOOKS=0"
        return 0
    fi

    local helper="$HOME/.config/zetup/ai-helpers/zetup-attention"
    if [[ ! -f "$helper" ]]; then
        echo "   ⚠️  Attention helper not found, skipping integration"
        return 0
    fi

    if python3 "$helper" install-hooks; then
        echo "   ✅ Tmux attention hooks/config installed"
    else
        echo "   ⚠️  Could not install tmux attention hooks/config"
        echo "   You can retry later with: zetup-attention install-hooks"
    fi

    if [[ -n "${TMUX:-}" ]]; then
        python3 "$helper" install-tmux-status >/dev/null 2>&1 || true
    fi
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

    # Ensure TPM is properly installed
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        echo "   ❌ TPM not found, cannot install plugins"
        return 1
    fi

    # Install plugins via TPM
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"

    # Verify Dracula theme was installed
    if [[ ! -d "$HOME/.tmux/plugins/tmux" ]]; then
        echo "   ⚠️  Dracula theme not found, installing manually..."
        git clone https://github.com/dracula/tmux.git "$HOME/.tmux/plugins/tmux"
    fi
}

verify_tmux_setup() {
    echo "🔍 Verifying tmux configuration..."
    
    # Check if pbcopy is available (required for copy/paste)
    if ! command -v pbcopy &> /dev/null; then
        echo "   ⚠️  Warning: pbcopy not found. Copy/paste functionality may not work."
    else
        echo "   ✅ pbcopy found - copy/paste will work"
    fi
    
    # Test tmux configuration syntax
    if tmux -f "$HOME/.tmux.conf" start-server \; list-keys > /dev/null 2>&1; then
        echo "   ✅ Tmux configuration is valid"
    else
        echo "   ❌ Tmux configuration has errors"
        return 1
    fi
}

main() {
    check_macos
    backup_existing_configs
    install_homebrew
    install_dependencies
    install_ai_assistant
    install_antigen
    install_tpm
    link_configs
    install_attention_hooks
    set_zsh_as_default
    install_tmux_plugins
    verify_tmux_setup
    
    echo ""
    echo "🎉 Zetup installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run 'exec zsh'"
    echo "2. Set your terminal font to 'FiraCode Nerd Font' for proper icon display"
    echo "   • iTerm2: Preferences > Profiles > Text > Font"
    echo "   • Terminal.app: Preferences > Profiles > Font"
    echo "3. Run 'tmux' to start a new session and see the Dracula theme"
    echo "4. Test copy/paste: Select text with mouse, then Cmd+V to paste"
    echo "5. Try AI assistant: 'list all files' or 'show git status'"
    echo "6. Customize machine-specific settings in ~/.config/zetup/local.zsh"
    echo "7. In tmux, Codex/Claude windows needing input show a blinking colored ● status icon"
    echo ""
    echo "Backup location: $BACKUP_DIR"
}

main "$@"
