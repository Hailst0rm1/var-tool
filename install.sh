#!/usr/bin/env zsh

# Installation script for Environment Variables Tool
# This script helps set up the tool and add it to your shell configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"
TOOL_SCRIPT="$SCRIPT_DIR/var.sh"
CONFIG_DIR="$HOME/.config"
ALIAS_NAME="var"

echo "🔧 Environment Variables Tool Installer"
echo "======================================="

# Check if ZSH is available
if ! command -v zsh &> /dev/null; then
    echo "❌ ZSH is not installed. Please install ZSH first."
    exit 1
fi

echo "✅ ZSH found: $(zsh --version)"

# Check ZSH version
ZSH_VERSION=$(zsh --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
if [[ "${ZSH_VERSION%%.*}" -lt 5 ]]; then
    echo "❌ ZSH version 5.0 or higher required (found: $ZSH_VERSION)"
    exit 1
fi

echo "✅ ZSH version compatible: $ZSH_VERSION"

# Check if script exists
if [[ ! -f "$TOOL_SCRIPT" ]]; then
    echo "❌ var.sh not found in $SCRIPT_DIR"
    exit 1
fi

echo "✅ Tool script found: $TOOL_SCRIPT"

# Make script executable
if ! chmod +x "$TOOL_SCRIPT"; then
    echo "❌ Failed to make script executable"
    exit 1
fi

echo "✅ Made script executable"

# Create config directory if it doesn't exist
if [[ ! -d "$CONFIG_DIR" ]]; then
    if ! mkdir -p "$CONFIG_DIR"; then
        echo "❌ Failed to create config directory: $CONFIG_DIR"
        exit 1
    fi
    echo "✅ Created config directory: $CONFIG_DIR"
else
    echo "✅ Config directory exists: $CONFIG_DIR"
fi

# Ask user about shell integration
echo ""
echo "🔗 Shell Integration Options:"
echo "1) Add alias to ~/.zshrc (recommended)"
echo "2) Add to PATH"
echo "3) Manual setup (no automatic integration)"
echo ""

read -r "choice?Select option (1-3): "

case "$choice" in
    1)
        ZSHRC="$HOME/.zshrc"
        ALIAS_LINE="alias $ALIAS_NAME='source \"$TOOL_SCRIPT\"'"
        
        if [[ -f "$ZSHRC" ]] && grep -q "alias $ALIAS_NAME=" "$ZSHRC"; then
            echo "⚠️  Alias '$ALIAS_NAME' already exists in $ZSHRC"
            read -r "overwrite?Overwrite existing alias? (y/N): "
            if [[ "$overwrite" =~ ^[Yy]$ ]]; then
                # Remove existing alias and add new one
                grep -v "alias $ALIAS_NAME=" "$ZSHRC" > "$ZSHRC.tmp" && mv "$ZSHRC.tmp" "$ZSHRC"
                echo "$ALIAS_LINE" >> "$ZSHRC"
                echo "✅ Updated alias in $ZSHRC"
            else
                echo "⏭️  Keeping existing alias"
            fi
        else
            echo "$ALIAS_LINE" >> "$ZSHRC"
            echo "✅ Added alias to $ZSHRC"
        fi
        
        echo ""
        echo "🎉 Installation complete!"
        echo "To use the tool:"
        echo "1. Restart your terminal or run: source ~/.zshrc"
        echo "2. Run: $ALIAS_NAME"
        ;;
        
    2)
        BIN_DIR="$HOME/.local/bin"
        if [[ ! -d "$BIN_DIR" ]]; then
            mkdir -p "$BIN_DIR"
            echo "✅ Created $BIN_DIR"
        fi
        
        SYMLINK="$BIN_DIR/$ALIAS_NAME"
        if [[ -L "$SYMLINK" ]] || [[ -f "$SYMLINK" ]]; then
            echo "⚠️  File already exists: $SYMLINK"
            read -r "overwrite?Overwrite? (y/N): "
            if [[ "$overwrite" =~ ^[Yy]$ ]]; then
                rm -f "$SYMLINK"
            else
                echo "⏭️  Keeping existing file"
                exit 0
            fi
        fi
        
        ln -s "$TOOL_SCRIPT" "$SYMLINK"
        echo "✅ Created symlink: $SYMLINK -> $TOOL_SCRIPT"
        
        # Check if ~/.local/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo ""
            echo "⚠️  $BIN_DIR is not in your PATH"
            echo "Add this to your ~/.zshrc:"
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
        
        echo ""
        echo "🎉 Installation complete!"
        echo "Run: $ALIAS_NAME"
        ;;
        
    3)
        echo ""
        echo "🎉 Setup complete!"
        echo "Manual usage:"
        echo "cd $SCRIPT_DIR"
        echo "source var.sh"
        ;;
        
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "📖 For help and documentation, run:"
echo "source \"$TOOL_SCRIPT\" --help"