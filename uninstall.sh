#!/bin/bash

set -e

echo "🗑️  Zetup - Uninstallation Script"
echo "================================="

# Find the most recent backup
BACKUP_DIR=$(find "$HOME" -maxdepth 1 -name ".zetup-backup-*" -type d | sort | tail -1)

if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
    echo "📦 Found backup directory: $BACKUP_DIR"
    
    read -p "Do you want to restore original configurations from backup? [y/N]: " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔄 Restoring original configurations..."
        
        [[ -f "$BACKUP_DIR/.zshrc" ]] && cp "$BACKUP_DIR/.zshrc" "$HOME/.zshrc"
        [[ -f "$BACKUP_DIR/.tmux.conf" ]] && cp "$BACKUP_DIR/.tmux.conf" "$HOME/.tmux.conf"
        [[ -d "$BACKUP_DIR/.tmux" ]] && cp -r "$BACKUP_DIR/.tmux" "$HOME/"
        
        echo "✅ Original configurations restored"
    fi
else
    echo "⚠️  No backup directory found. Proceeding with removal only."
fi

read -p "Do you want to remove Zetup configurations? [y/N]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️  Removing Zetup configurations..."
    
    # Remove symlinked configs (if they point to Zetup)
    if [[ -L "$HOME/.zshrc" ]]; then
        rm "$HOME/.zshrc"
        echo "   Removed ~/.zshrc symlink"
    fi
    
    if [[ -L "$HOME/.tmux.conf" ]]; then
        rm "$HOME/.tmux.conf"
        echo "   Removed ~/.tmux.conf symlink"
    fi
    
    # Remove Zetup directory
    if [[ -d "$HOME/.config/zetup" ]]; then
        rm -rf "$HOME/.config/zetup"
        echo "   Removed ~/.config/zetup directory"
    fi
    
    echo "✅ Zetup configurations removed"
fi

read -p "Do you want to remove Antigen? [y/N]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ -f "$HOME/.antigen.zsh" ]]; then
        rm "$HOME/.antigen.zsh"
        echo "✅ Antigen removed"
    else
        echo "   Antigen not found"
    fi
fi

read -p "Do you want to remove TPM and tmux plugins? [y/N]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ -d "$HOME/.tmux/plugins" ]]; then
        rm -rf "$HOME/.tmux/plugins"
        echo "✅ TPM and tmux plugins removed"
    else
        echo "   TPM/tmux plugins not found"
    fi
fi

read -p "Do you want to reset shell to system default? [y/N]: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🐚 Resetting shell to system default..."
    chsh -s /bin/zsh
    echo "✅ Shell reset to /bin/zsh"
fi

echo ""
echo "🎉 Uninstallation complete!"
echo ""
echo "Note: Homebrew and installed packages (zsh, tmux, git) were not removed."
echo "You can remove them manually with: brew uninstall zsh tmux git"
echo ""
echo "Backup directory (if exists): $BACKUP_DIR"