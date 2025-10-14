# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git
zsh-autosuggestions
F-Sy-H
zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Prevent accidental Ctrl+D from closing the shell
setopt IGNORE_EOF
# Make Ctrl+D delete word forward (like Alt+d)
bindkey '^D' backward-kill-word

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias clear="/usr/bin/clear"
alias cls='clear'
alias sp="tmux kill-session -t spotify_player 2>/dev/null; tmux new-session -d -s spotify_player 'spotify_player'"

# Environment variables
export CUDA_HOME=/usr/local/cuda-12.6
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64  # Remove any references to cuda-12.8
export CUDA_DEVICE_ORDER="PCI_BUS_ID"
export TORCH_CUDA_ARCH_LIST="7.5"

# Conda initialize
__conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
# . "$HOME/miniforge3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
# export PATH="$HOME/miniforge3/bin:$PATH"  # commented out by conda initialize
    fi
fi
unset __conda_setup

# Mamba setup
# if [ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]; then
#     . "$HOME/miniforge3/etc/profile.d/mamba.sh"
#     # mamba activate base
#
#     # Fix terminal settings AFTER mamba activation
#     export TERMINFO=/usr/share/terminfo
#     if [ -n "$TMUX" ]; then
#         export TERM=screen-256color
#     else
#         export TERM=xterm-kitty
#     fi
# fi

# Always set TERMINFO after any conda/mamba activation
export TERMINFO=/usr/share/terminfo

# History settings
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
HISTSIZE=1000
HISTFILESIZE=2000

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/nhomnhom0/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/nhomnhom0/miniforge3/etc/profile.d/conda.sh" ]; then
#         . "/home/nhomnhom0/miniforge3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/nhomnhom0/miniforge3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
if [ -n "$MAMBA_EXE" ] && [ -x "$MAMBA_EXE" ]; then
    __mamba_setup="$($MAMBA_EXE shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"
    fi
    unset __mamba_setup
fi
# <<< mamba initialize <<<
