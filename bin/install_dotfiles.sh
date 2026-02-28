#!/bin/bash

echo "👋 Hello! Installing my dotfiles…"

# Clone or update the repo
if [ -d "$HOME/my-dotfiles" ]; then
    echo "Updating existing dotfiles…"
    git -C "$HOME/my-dotfiles" pull
else
    echo "Cloning dotfiles…"
    git clone https://github.com/NhomNhom0/my-dotfiles "$HOME/my-dotfiles"
fi

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
required_commands=("zsh" "git" "neofetch" "kitty" "btop" "rofi")

# Check for fonts-noto-color-emoji (emoji font, not a binary)
if ! fc-list | grep -qi "NotoColorEmoji"; then
    echo "❌ Please install fonts-noto-color-emoji (Noto Color Emoji font)!"
    exit 1
fi
echo "📋 Checking required packages..."
for cmd in "${required_commands[@]}"; do
    if ! check_command "$cmd"; then
        exit 1
    fi
done

# Check for LightDM (service, not command)
if [ ! -f "/usr/sbin/lightdm" ] && [ ! -f "/usr/bin/lightdm" ]; then
    echo "❌ Please install lightdm!"
    exit 1
fi

# Check for lightdm-gtk-greeter binary
if [ ! -f "/usr/sbin/lightdm-gtk-greeter" ] && [ ! -f "/usr/bin/lightdm-gtk-greeter" ]; then
    echo "❌ Please install lightdm-gtk-greeter!"
    exit 1
fi

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

# Create symlinks for dotfiles
echo "Creating symlinks for dotfiles…"
ln -sf $HOME/my-dotfiles/zsh/.p10k.zsh $HOME/.p10k.zsh
ln -sf $HOME/my-dotfiles/zsh/.zprofile $HOME/.zprofile
ln -sf $HOME/my-dotfiles/zsh/.zshrc $HOME/.zshrc
sudo ln -sf $HOME/my-dotfiles/fonts/* /usr/share/fonts/truetype
sudo ln -sf $HOME/my-dotfiles/themes/* /usr/share/themes/

# Symlink icons folder to global icons directory for icon themes
if [ -d "$HOME/my-dotfiles/icons" ]; then
    sudo ln -sf $HOME/my-dotfiles/icons/* /usr/share/icons/
fi

# Handle .config directories and symlinks
for config_dir in "neofetch" "kitty" "btop" "spotify-player" "rofi"; do
    config_path="$HOME/.config/$config_dir"
    dotfiles_path="$HOME/my-dotfiles/$config_dir"

    if [ ! -d "$config_path" ]; then
        echo "Creating directory: $config_path"
        mkdir -p "$config_path"
    fi

    # Remove any existing files or directories in the config path
    find "$config_path" -mindepth 1 -delete

    # Create the symlink
    echo "Creating symlink: $config_path -> $dotfiles_path"
    ln -sf $dotfiles_path/* $config_path/
done

# Symlink for XFCE panel and GTK config

# 1. xfce4-panel.xml
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
xfce_panel_target="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
if [ -e "$xfce_panel_target" ] && [ ! -L "$xfce_panel_target" ]; then
    read -p "File $xfce_panel_target exists and is not a symlink. Overwrite with symlink? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm -f "$xfce_panel_target"
        ln -sf "$HOME/my-dotfiles/xfce-panel/xfce4-panel.xml" "$xfce_panel_target"
        echo "Symlinked $xfce_panel_target."
    else
        echo "Skipped $xfce_panel_target."
    fi
elif [ ! -L "$xfce_panel_target" ]; then
    ln -sf "$HOME/my-dotfiles/xfce-panel/xfce4-panel.xml" "$xfce_panel_target"
fi

# 2. xfce4 panel directory
mkdir -p "$HOME/.config/xfce4/panel"
for file in $HOME/my-dotfiles/xfce-panel/panel/*; do
    target="$HOME/.config/xfce4/panel/$(basename "$file")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        read -p "File $target exists and is not a symlink. Overwrite with symlink? [y/N] " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            rm -f "$target"
            ln -sf "$file" "$target"
            echo "Symlinked $target."
        else
            echo "Skipped $target."
        fi
    elif [ ! -L "$target" ]; then
        ln -sf "$file" "$target"
    fi
done

# 3. gtk-3.0 gtk.css
mkdir -p "$HOME/.config/gtk-3.0"
gtk_css_target="$HOME/.config/gtk-3.0/gtk.css"
if [ -e "$gtk_css_target" ] && [ ! -L "$gtk_css_target" ]; then
    read -p "File $gtk_css_target exists and is not a symlink. Overwrite with symlink? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm -f "$gtk_css_target"
        ln -sf "$HOME/my-dotfiles/xfce-panel/gtk.css" "$gtk_css_target"
        echo "Symlinked $gtk_css_target."
    else
        echo "Skipped $gtk_css_target."
    fi
elif [ ! -L "$gtk_css_target" ]; then
    ln -sf "$HOME/my-dotfiles/xfce-panel/gtk.css" "$gtk_css_target"
fi

# 4. xfce4-keyboard-shortcuts.xml
keyboard_shortcuts_target="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml"
if [ -e "$keyboard_shortcuts_target" ] && [ ! -L "$keyboard_shortcuts_target" ]; then
    read -p "File $keyboard_shortcuts_target exists and is not a symlink. Overwrite with symlink? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm -f "$keyboard_shortcuts_target"
        ln -sf "$HOME/my-dotfiles/keyboard-shortcut/xfce4-keyboard-shortcuts.xml" "$keyboard_shortcuts_target"
        echo "Symlinked $keyboard_shortcuts_target."
    else
        echo "Skipped $keyboard_shortcuts_target."
    fi
elif [ ! -L "$keyboard_shortcuts_target" ]; then
    ln -sf "$HOME/my-dotfiles/keyboard-shortcut/xfce4-keyboard-shortcuts.xml" "$keyboard_shortcuts_target"
fi

# 5. xfwm4.xml
xfwm4_target="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
if [ -e "$xfwm4_target" ] && [ ! -L "$xfwm4_target" ]; then
    read -p "File $xfwm4_target exists and is not a symlink. Overwrite with symlink? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm -f "$xfwm4_target"
        ln -sf "$HOME/my-dotfiles/keyboard-shortcut/xfwm4.xml" "$xfwm4_target"
        echo "Symlinked $xfwm4_target."
    else
        echo "Skipped $xfwm4_target."
    fi
elif [ ! -L "$xfwm4_target" ]; then
    ln -sf "$HOME/my-dotfiles/keyboard-shortcut/xfwm4.xml" "$xfwm4_target"
fi

# Symlink LightDM main config
if [ ! -L "/etc/lightdm/lightdm.conf" ]; then
    sudo ln -sf "$HOME/my-dotfiles/lockscreen/lightdm.conf" /etc/lightdm/lightdm.conf
fi

# Symlink LightDM configuration
dest_dir="/usr/share/lightdm/lightdm.conf.d/"
sudo mkdir -p "$dest_dir"
for file in $HOME/my-dotfiles/lockscreen/lightdm.conf.d/*; do
    target="$dest_dir$(basename "$file")"
    if [ ! -L "$target" ]; then
        sudo ln -sf "$file" "$target"
    fi
done

# Symlink backgrounds
dest_bg="/usr/share/backgrounds/"
sudo mkdir -p "$dest_bg"
for file in $HOME/my-dotfiles/lockscreen/background/*; do
    target="$dest_bg$(basename "$file")"
    if [ ! -L "$target" ]; then
        sudo ln -sf "$file" "$target"
    fi
done

# Symlink LightDM GTK Greeter config
if [ ! -L "/etc/lightdm/lightdm-gtk-greeter.conf" ]; then
    sudo ln -sf "$HOME/my-dotfiles/lockscreen/lightdm-gtk-greeter.conf" /etc/lightdm/lightdm-gtk-greeter.conf
fi
# sudo chmod 644 /etc/lightdm/lightdm-gtk-greeter.conf


# Symlink all .sh files in rofi and its subfolders to /usr/local/bin and make them executable
find "$HOME/my-dotfiles/" -type f -name "*.sh" | while read -r script; do
    script_name=$(basename "$script" .sh)
    target="/usr/local/bin/$script_name"
    if [ ! -L "$target" ]; then
        sudo ln -sf "$script" "$target"
    fi
    sudo chmod +x "$script"
done


# Symlink lightdm-xset-disable.sh specifically to /usr/local/bin
if [ -f "$HOME/my-dotfiles/bin/lightdm-xset-disable.sh" ]; then
    sudo ln -sf "$HOME/my-dotfiles/bin/lightdm-xset-disable.sh" /usr/local/bin/lightdm-xset-disable.sh
    sudo chmod +x /usr/local/bin/lightdm-xset-disable.sh
fi

# Symlink fontconfig local.conf to /etc/fonts/local.conf
if [ -f "$HOME/my-dotfiles/font_config/local.conf" ]; then
    sudo ln -sf "$HOME/my-dotfiles/font_config/local.conf" /etc/fonts/local.conf
fi

# Ensure permissions for LightDM and other services to access backgrounds
chmod o+rx "$HOME"
chmod o+rx "$HOME/my-dotfiles"
chmod -R o+r "$HOME/my-dotfiles/lockscreen/background"

# Set zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "To set zsh as the default shell, run the following command:"
    echo "chsh -s $(which zsh)"
fi