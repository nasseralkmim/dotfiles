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
# the promp needs to be simple
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
alias e="emacs -nw -fg white -bg black"
alias ec="emacsclient --no-wait"

# better color support (-256color)
export TERM=screen-256color

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

# 
# For chapel
# 
# Find out filepath depending on shell
if [ -n "${BASH_VERSION}" ]; then
    filepath=${BASH_SOURCE[0]}
elif [ -n "${ZSH_VERSION}" ]; then
    filepath=${(%):-%N}
else
    echo "Error: setchplenv.bash can only be sourced from bash and zsh"
    return 1
fi

# Directory of setchplenv script, will not work if script is a symlink
DIR=$(cd "$(dirname "${filepath}")" && pwd)

# Shallow test to see if we are in the correct directory
# Just probe to see if we have a few essential subdirectories --
# indicating that we are probably in a Chapel root directory.
chpl_home=$( cd $DIR/../ && pwd )
if [ ! -d "$chpl_home/util" ] || [ ! -d "$chpl_home/compiler" ] || [ ! -d "$chpl_home/runtime" ] || [ ! -d "$chpl_home/modules" ]; then
    # Chapel home is assumed to be one directory up from setenvchpl.bash script
    echo "Error: \$CHPL_HOME is not where it is expected"
    return 1
fi

CHPL_PYTHON=`$chpl_home/util/config/find-python.sh`

# Remove any previously existing CHPL_HOME paths
MYPATH=`$CHPL_PYTHON $chpl_home/util/config/fixpath.py "$PATH"`
exitcode=$?
MYMANPATH=`$CHPL_PYTHON $chpl_home/util/config/fixpath.py "$MANPATH"`

# Double check $MYPATH before overwriting $PATH
if [ -z "${MYPATH}" -o "${exitcode}" -ne 0 ]; then
    echo "Error:  util/config/fixpath.py failed"
    echo "        Make sure you have Python 2.5+"
    return 1
fi

export CHPL_HOME=$chpl_home
# echo "Setting CHPL_HOME to $CHPL_HOME"

CHPL_BIN_SUBDIR=`$CHPL_PYTHON "$CHPL_HOME"/util/chplenv/chpl_bin_subdir.py`

export PATH="$CHPL_HOME"/bin/$CHPL_BIN_SUBDIR:"$CHPL_HOME"/util:"$MYPATH"
# echo "Updating PATH to include $CHPL_HOME/bin/$CHPL_BIN_SUBDIR"
# echo "                     and $CHPL_HOME/util"

export MANPATH="$CHPL_HOME"/man:"$MYMANPATH"
# echo "Updating MANPATH to include $CHPL_HOME/man"
# 
# end chapel
# 
