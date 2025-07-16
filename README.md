# my-dotfiles

This repo contains my personal configuration files for my Linux setup. I use Debian Bookworm with the XFCE desktop environment, and these configs are tailored for my workflow, appearance preferences, and hardware.

## System Info
- **Distro:** Debian Bookworm
- **Desktop Environment:** XFCE
- **Display Manager:** LightDM (GTK Greeter)
- **Terminal:** Kitty

## What these configs do
- **XFCE Panel & GTK:** Custom CSS for panel appearance, rounded corners, and Catppuccin color tweaks.
- **LightDM:** Greeter config for lockscreen, custom backgrounds, and icon themes.
- **Kitty:** Terminal color schemes and font settings.
- **Neofetch:** System info with custom ASCII art.
- **Rofi:** Launcher and power menu scripts, themed for consistency.
- **Fonts & Icons:** Nerd Fonts and Catppuccin icons for better compatibility and looks.
- **Keyboard Shortcuts:** My personal keybindings for XFCE and window manager.
- **Spotify Player:** Config for the TUI client.
- **Cava & Btop:** Visualizer and system monitor themes.
- **Zsh:** Shell config, plugins, and prompt theme (Powerlevel10k).

## Installation
You can use the install script to set up symlinks and dependencies:

```bash
curl -fsSL https://raw.githubusercontent.com/NhomNhom0/my-dotfiles/main/bin/install.sh | bash
```

## Credits
- [Catppuccin](https://catppuccin.com/) for themes and icons
- [Nerd Fonts](https://www.nerdfonts.com/) for patched fonts
