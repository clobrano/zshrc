# Set up the prompt

#autoload -Uz promptinit
#promptinit
#prompt adam1

setopt histignorealldups sharehistory
setopt PROMPT_SUBST
# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*' special-dirs true

# ===============================================================0
# Custom configuration
# ===============================================================0
# Aliases
alias ls='ls --color'
alias ll='ls -l --color'

# Generic alias for work
alias workspace='cd ~/workspace'
alias toolkit='cd ~/toolkit'

alias ofono='cd ~/workspace/ofono-telit/ofono'
alias ofono-test='cd ~/workspace/ofono-telit/ofono/test'


export TODO_HOME=/home/carlo/toolkit/todo.txt-cli/
export TODO_SH=${TODO_HOME}/todo.sh
export EDITOR=gvim

alias todo.sh='"$TODO_HOME"/todo.sh'
alias todo='"$TODO_HOME"/todo.sh -t'

alias tadd='"$TODO_HOME"/todo.sh -t add'
alias ta='"$TODO_HOME"/todo.sh -t add'

alias openpoints='"$TODO_HOME"/todo.sh projectview -+done -+fixed -+rejected -+wontdo -+sometime -@actions'
alias op='"$TODO_HOME"/todo.sh projectview -+done -+fixed -+rejected -+wontdo -+sometime -@actions'

alias tnow='"$TODO_HOME"/todo.sh donow '
alias tn='"$TODO_HOME"/todo.sh donow '
alias opo='"$TODO_HOME"/todo.sh projectview -+done -+fixed -+rejected -+wontdo -+sometime -@actions +ofono'

alias opr='raffaello "\(A\)=>red_bold" "\(B\)=>yellow" "\(C\)=>green" "\d{4}-\d{2}-\d+=>cyan" "\+\w+=>red" "min:\d+=>purple" --- cat ~/toolkit/todo.txt-cli/todo.txt'
alias report='raffaello "\(A\)=>red_bold" "\(B\)=>yellow" "\(C\)=>green" "\d{4}-\d{2}-\d+=>cyan" "\+\w+=>red" "min:\d+=>purple" --- cat ~/toolkit/todo.txt-cli/done.txt'
alias tao='"$TODO_HOME"/todo.sh -t add +ofono'



# ==============================================
# GIT aliases
alias gl='git log --decorate=short'

alias gstatus='git status'
alias gs='git status'

alias gd='git diff -w'
alias gdif='git difftool --no-prompt --extcmd "icdiff --line-numbers --highlight"'

alias ga='git add'

alias gcommit='git commit'

alias ghistory='git log --decorate --oneline --graph --all --date=short --pretty=format:"%C(auto)%d%Creset %C(auto)%h%Creset - %C(cyan)%an%Creset %Cgreen(%ad)%Creset : %s" '
alias gh='git log --decorate --oneline --graph --all --date=short --pretty=format:"%C(auto)%d%Creset %C(auto)%h%Creset - %C(cyan)%an%Creset %Cgreen(%ad)%Creset : %s" '
# ==============================================



alias rmake='raffaello --file=~/toolkit/raffaello/examples/make.cfg --- make'

alias gvimr='gvim --remote-silent'

# ===============================================================
# GIT status info in command-line

_prompt_git_status(){
    local __git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [ -n "${__git_branch}" ]; then
        local __git_modified=$(git status --porcelain --untracked-files=no 2>/dev/null | wc -l )

        if [ -n "${__git_modified}" ]; then
            if [ "0" = "${__git_modified}" ]; then
                echo -n "-"
            else
                echo -n '↪ '
            fi
        fi

        local __git_stash=$(git stash list 2>/dev/null | wc -l)
        if [ -n "${__git_stash}" ]; then
            if [ "0" = "${__git_stash}" ]; then
                echo -n "-"
            else
                echo -n " %F{red}S${__git_stash}%f "
            fi
        fi

        echo -n '%F{cyan}'$__git_branch'%f'
        local __git_tag=$(git describe --tag --abbrev=0 2>/dev/null)
        if [ ! -z ${__git_tag} ]; then
            echo -n "-%F{green}${__git_tag}%f"
        fi
    fi
}

# CCACHE for android build 2015-02-09
export USE_CCACHE=1

# ===============================================================
# Updating PATH
# ===============================================================
PATH=$PATH:$TODO_HOME
PATH=$PATH:~/toolkit/icdiff
PATH=$PATH:~/toolkit
PATH=~/bin:$PATH

# Android
PATH=$PATH:~/workspace/android-x86/out/host/linux-x86/bin/
PATH=$PATH:~/workspace/android-x86/ndk
PATH=$PATH:~/workspace/android-ndk-r10d


# History is shared only with child session
setopt no_share_history


# ===============================================================
# prompt
__prompt_line()
{
    echo -n "Iam%n%"
}

if [ ${USER} = root ]; then
    PROMPT='%F{red}$(__prompt_line)f# '
else
    PROMPT='%F{yellow}$(__prompt_line)f> '
fi
RPROMPT='$(_prompt_git_status) %2c %F{yellow} %T%f'

# NOTE: run
#   chsh -s /bin/zsh
# to use zsh as root shell
