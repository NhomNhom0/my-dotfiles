#!/bin/bash

echo "👋 Hello! Installing my dotfiles…"

# Helper function for command checks
check_command() {
    local tool=$1

    echo -n "Checking for $tool... "
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo ""
        echo "❌ Please install $tool!"
        return 1
    else
        echo ""
        return 0
    fi
}

# Check required binaries
required_commands=("zsh" "git" "neofetch" "kitty")
missing_any=false

echo "📋 Checking required packages..."
for cmd in "${required_commands[@]}"; do
    if ! check_command "$cmd"; then
        exit 1
    fi
done
echo "📦 All required packages are installed"

# Check if oh-my-zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh…"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Function to install ZSH plugins/themes
install_zsh_addon() {
    local name=$1
    local type=$2
    local repo=$3
    local path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/${type}/${name}"
    local git_options=$4
    
    if [ ! -d "$path" ]; then
        echo "Installing $name $type…"
        git clone $git_options "$repo" "$path"
    else
        echo "✅ $name $type is already installed"
    fi
}

# Install themes and plugins
echo "🔌 Installing Oh My Zsh addons..."
install_zsh_addon "powerlevel10k" "themes" "https://github.com/romkatv/powerlevel10k.git" "--depth=1"
install_zsh_addon "zsh-autosuggestions" "plugins" "https://github.com/zsh-users/zsh-autosuggestions"
install_zsh_addon "F-Sy-H" "plugins" "https://github.com/z-shell/F-Sy-H.git"
install_zsh_addon "zsh-history-substring-search" "plugins" "https://github.com/zsh-users/zsh-history-substring-search"

# Clone or update the repo
if [ -d "$HOME/my-dotfiles" ]; then
    echo "Updating existing dotfiles…"
    git -C "$HOME/my-dotfiles" pull
else
    echo "Cloning dotfiles…"
    git clone https://github.com/NhomNhom0/my-dotfiles "$HOME/my-dotfiles"
fi

# Create symlinks for dotfiles
echo "Creating symlinks for dotfiles…"
ln -sf "$HOME/my-dotfiles/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/my-dotfiles/zsh/p10k.zsh" "$HOME/.p10k.zsh"
ln -sf $HOME/my-dotfiles/neofetch/* $HOME/.config/neofetch/
ln -sf $HOME/my-dotfiles/kitty/* $HOME/.config/kitty/

# Set zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "To set zsh as the default shell, run the following command:"
    echo "chsh -s $(which zsh)"
fi