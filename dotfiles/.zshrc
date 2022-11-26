

### Environment variables and Configs ###

bindkey -e
# # End of lines configured by zsh-newuser-install
# # The following lines were added by compinstall
# zstyle :compinstall filename '~/.zshrc'

# # End of lines added by compinstall

### Key binds ###

bindkey '^G' fzf-file-widget
bindkey -M emacs '^[[3;5~' kill-word
bindkey '^P' fzf-process-widget
bindkey '^O' fzf-port-widget
autoload -U select-word-style
select-word-style bash

bindkey '^H' force-backward-delete-word
bindkey "^[[1;7D" dirhistory_zle_dirhistory_back
bindkey "^[[1;7C" dirhistory_zle_dirhistory_future
# bindkey "^[[1;7C" dirhistory_zle_dirhistory_up
# bindkey "^[[1;7C" dirhistory_zle_dirhistory_down

### Aliases ###

[ -f ~/nix-config/dotfiles/.kubectl_aliases ] && source ~/nix-config/dotfiles/.kubectl_aliases


### Theme ###

typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|make'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs newline prompt_char)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator command_execution_time background_jobs history direnv goenv nodeenv fvm kubecontext terraform context nordvpn nnn midnight_commander nix_shell time newline go_version)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time direnv kubecontext context nix_shell time)

## COMPLETIONS ########################################


### Functions ###
fzf-process-widget() {
    local pid=( $(ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' ') )
    LBUFFER="${LBUFFER}${pid}"
}
zle -N fzf-process-widget

fzf-port-widget() {
    sudo true
    local port=( $(sudo lsof -i -P -n | fzf | sed 's/^ *//' | tr -s " " | cut -f2 -d' ') )
    LBUFFER="${LBUFFER}${port}"
}
zle -N fzf-port-widget

force-backward-delete-word () {
    local WORDCHARS='~!#$%^&*(){}[]<>?+_-/;'
    zle backward-delete-word
}
zle -N force-backward-delete-word

fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && echo "opening $file" && open "$file" || return 1;
}

rga-fzf() {
    RG_PREFIX="rga --files-with-matches"
    local file
    file="$(
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                --phony -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap"
    )" &&
    echo "opening $file" &&
    xdg-open "$file"
}

# sfs creates a temporary directory and mounts a remote filesystem to it. Usage: sfs core@ares.unchain.io
sfs() {
    mkdir /tmp/$1
    sshfs $1:/ /tmp/$1

    # Replace dolphin with the file explorer you use
    nohup dolphin /tmp/$1 &>/dev/null &
}

# sin adds a new entry to your ssh config file. Usage: sin ares core ares.unchain.io
sin() {
cat << EOF >> ~/.ssh/config

Host $1
    User $2
    HostName $3

EOF
}
