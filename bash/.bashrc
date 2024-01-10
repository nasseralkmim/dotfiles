# ~/.bashrc: executed by bash(1) for non-login shells.

# add ~/.local/bin to path
export PATH="${PATH}:/home/nasser/.local/bin"

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

if [ -f "/home/nasser/miniconda3/etc/profile.d/mamba.sh" ]; then
    . "/home/nasser/miniconda3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# go language for singularity
export "GOPATH=${HOME}/go"
export PATH="/usr/local/go/bin:${PATH}:${GOPATH}/bin"

# for vterm (in emacs)
# add functions to enable the shell to send information to vterm
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

# For using tramp
# the prompt needs to be simple
case "$TERM" in
	"dumb")
		PS1="> "
esac

#
# Aliases
#
# for running edelweissfe
alias edelweissfe="~/miniconda3/envs/edelweissfe/bin/python ~/.local/src/EdelweissFE/edelweiss.py"

# for paraview (note that "''" because of spaces in the path)
alias pvpython="'/mnt/c/Program Files/ParaView 5.9.1-Windows-Python3.8-msvc2017-64bit/bin/pvpython.exe'"

# emacs
# -nw no window, open on current terminal
# -a '' if there is no client
alias e="emacs -nw"
alias ec="emacsclient --no-wait"

# better color support (-256color)
# 'screen-256color' is ok and supported by most hosts by default
# 'xterm-direct' is also good
export TERM=xterm-24bits

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk/
export PATH=$JAVA_HOME/jre/bin:$PATH

# editor for sudo -e
export SUDO_EDITOR="emacs -nw"

# abaqus with singularity
# &: runs in the background
# disown: remove from SHELL jobm control (can close terminal)
# - mesa for hardware acceleration
alias abaqus="singularity exec ~/Containers/abaqus-2019-centos-7-may-2020_ii.simg abaqus"
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# for remote work
alias uibk='sudo openconnect vpn.uibk.ac.at -u c8441205 -b'
alias fw='google-chrome-stable https://fwauth-tech.uibk.ac.at/'
export workstation=nasser@138.232.83.174
export alienware=nasser@138.232.83.149
export threadripper=nasser@138.232.83.171
alias sshfsrem='sshfs -o allow_other $remote:/home/nasser/Abaqus /home/nasser/Abaqus'

# backup to spare workstation work related
export workrepo="sftp:$alienware:/home/nasser/Backup"
alias workbackup="restic -r $workrepo --verbose backup ~/Experiments"

export homerepo="b2:thinkpad-t14s:Documents"

# alias for apptainer
alias apptshell="sudo apptainer shell --writable"

# For Emacs Vterm prompt track
# Needs to be at end
# https://github.com/akermu/emacs-libvterm#:~:text=For%20bash%2C%20put%20this%20at%20the%20end%20of%20your%20.bashrc%3A
# For directory tracking and prompt tracking
# directory tracking: default directory and current directory in vterm are synced
# prompt tracking: emacs knows where the prompt ends.
vterm_prompt_end(){
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
PS1=$PS1'\[$(vterm_prompt_end)\]'
