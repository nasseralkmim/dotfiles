# ~/.bashrc: executed by bash(1) for non-login shells.

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/nasser/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/nasser/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/nasser/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/nasser/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias proj='cd /mnt/c/Users/c8441205/OneDrive/Academy/PhD/projects'
alias soft='cd /mnt/c/Users/c8441205/OneDrive/Academy/PhD/softwares'

# go language for singularity
export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin


# for vterm
vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# prompt string
#\u - user name
#\h - short hostname
#\W - current working dir
#\? - exit status of the command
export PS1="[\[\e[32m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]:\W]$ "
