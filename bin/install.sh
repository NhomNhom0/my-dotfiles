#!/bin/bash

echo "👋 Hello! Installing my dotfiles…"

# Check if zsh is installed
if ! command -v zsh >/dev/null 2>&1; then
    echo "Please install zsh!"
    exit 1
else
    echo "✅ Zsh has been installed"
fi
# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Please install git!"
    exit 1
fi
# Check if oh-my-zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh…"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✅ Oh-my-zsh is already installed"
fi
# Check neofetch is installed
if ! command -v neofetch >/dev/null 2>&1; then
    echo "Please install neofetch!"
    exit 1
else
    echo "✅ Neofetch is already installed"
fi

# Install Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme…"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
    echo "✅ Powerlevel10k theme is already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin…"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "✅ zsh-autosuggestions plugin is already installed"
fi

# Install F-Sy-H plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/F-Sy-H" ]; then
    echo "Installing F-Sy-H plugin…"
    git clone https://github.com/z-shell/F-Sy-H.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H
else
    echo "✅ F-Sy-H plugin is already installed"
fi

# Install zsh-history-substring-search plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search" ]; then
    echo "Installing zsh-history-substring-search plugin…"
     git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
else
    echo "✅ zsh-history-substring-search plugin is already installed"
fi

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
ln -sf "$HOME/my-dotfiles/neofetch/config.conf" "$HOME/.config/neofetch/config.conf"

# Set zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting zsh as the default shell…"
    sudo chsh -s "$(which zsh)" "$USER"
else
    echo "✅ Zsh is already the default shell"
fi