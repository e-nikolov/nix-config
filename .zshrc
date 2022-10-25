
# Only execute the nix.sh once per shell.
if [ -z "${__ETC_PROFILE_NIX_SOURCED:-}" ]; then
    # __ETC_PROFILE_NIX_SOURCED=1
    export __ETC_PROFILE_NIX_SOURCED=1

    if [ -e /home/enikolov/.nix-profile/etc/profile.d/nix.sh ]; then . /home/enikolov/.nix-profile/etc/profile.d/nix.sh; fi 
fi

# autoload -Uz compinit
# compinit
autoload bashcompinit && bashcompinit
zmodload -i zsh/complist

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light trystan2k/zsh-tab-title
### End of Zinit's installer chunk

### Environment variables and Configs ###

# export GPG_TTY=$TTY

zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent lifetime 10m

setopt histignorealldups sharehistory

bindkey -e
# # End of lines configured by zsh-newuser-install
# # The following lines were added by compinstall
# zstyle :compinstall filename '~/.zshrc'

# # End of lines added by compinstall

### Plugins ###
# zinit ice depth=1; zinit light romkatv/powerlevel10k
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# # Load a few important annexes, without Turbo
# # (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

#  atinit"zicompinit; zicdreplay" \

zinit wait lucid light-mode for \
    blockf \
        zsh-users/zsh-completions \
    pick"git-it-on.plugin.zsh" \
        peterhurford/git-it-on.zsh

# zinit light-mode for \
#     pick"zsh-lazyload.zsh" \
#         qoomon/zsh-lazyload

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
# zinit snippet OMZP::common-aliases
zinit snippet OMZP::debian
# zinit snippet OMZP::command-not-found
zinit snippet OMZP::sudo
zinit snippet OMZP::golang
# zinit load rupa/z
# zinit load changyuheng/fz
zinit snippet OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh
# zinit load zdharma-continuum/zui
# zinit load zdharma-continuum/zbrowse
# zinit light zdharma-continuum/zinit-crasis
zinit load "djui/alias-tips"
zinit snippet OMZP::colored-man-pages
# zinit ice from"gh-r" as"program"
# zinit load asdf-vm/asdf
# zinit pack"binary+keys" for fzf
zinit load Aloxaf/fzf-tab
zinit load zimfw/input

. ~/.config/nixpkgs/text-selections.zsh
# export ACTION_CUT_SELECTION=$'^X'
# zinit multisrc"{text-selections,echo-quoted-line}/*.zsh" for e-nikolov/zinit-plugins
# zinit multisrc"echo-quoted-line/*.zsh" for e-nikolov/zinit-plugins

### Key binds ###

bindkey '^G' fzf-file-widget
# bindkey '^H' my-backward-delete-word
# bindkey '^H' tcsh-backward-delete-word
# bindkey '^[[1;5C' forward-word
# bindkey '^[[1;5D' backward-word
# bindkey '^[[1;7D' emacs-backward-word
# bindkey '^[[1;7C' emacs-forward-word
# bindkey '^[[1;3D' emacs-backward-word
# bindkey '^[[1;3C' emacs-forward-word
# bindkey '^H' backward-kill-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey '^P' fzf-process-widget
autoload -U select-word-style
select-word-style bash

### Aliases ###

[ -f ~/.config/nixpkgs/.kubectl_aliases ] && source ~/.config/nixpkgs/.kubectl_aliases

unalias age

xc() {
    xclip -selection clipboard
}

# alias pp="ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' '"
fzf-process-widget() {
    # local cmd="ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' '"
    local pid=( $(ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' ') )
    LBUFFER="${LBUFFER}${pid}"
}

zle -N fzf-process-widget


### Theme ###

typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|make'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(kubecontext os_icon dir vcs newline prompt_char)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status asdf root_indicator command_execution_time background_jobs history direnv virtualenv anaconda pyenv goenv nodeenv fvm luaenv jenv plenv phpenv scalaenv haskell_stack kubecontext terraform aws aws_eb_env azure gcloud google_app_cred context nordvpn ranger nnn vim_shell midnight_commander nix_shell todo timewarrior taskwarrior time newline)
typeset -g POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW=true
typeset -g POWERLEVEL9K_ASDF_NODEJS_SHOW_ON_UPGLOB='*.js|package.json'
typeset -g POWERLEVEL9K_ASDF_RUBY_SHOW_ON_UPGLOB='*.rb'
typeset -g POWERLEVEL9K_ASDF_PYTHON_SHOW_ON_UPGLOB='*.py'
typeset -g POWERLEVEL9K_ASDF_ERLANG_SHOW_ON_UPGLOB='mix.lock|*.ex'
typeset -g POWERLEVEL9K_ASDF_ELIXIR_SHOW_ON_UPGLOB='mix.lock|*.ex'
typeset -g POWERLEVEL9K_ASDF_GOLANG_SHOW_ON_UPGLOB='go.mod'
typeset -g POWERLEVEL9K_ASDF_RUST_SHOW_ON_UPGLOB='Cargo.lock|Cargo.toml|*.rs'
typeset -g POWERLEVEL9K_ASDF_SOLIDITY_SHOW_ON_UPGLOB='truffle-config.js|*.sol'
typeset -g POWERLEVEL9K_ASDF_SQLITE_SHOW_ON_UPGLOB='*.sqlite'

## COMPLETIONS ########################################

WORDCHARS=''
unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt list_packed
setopt nolistbeep
setopt list_packed

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

command -v vault > /dev/null && complete -o nospace -C vault vault
command -v ent > /dev/null && source <(ent completion zsh) && compdef _ent ent

### Functions ###

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

docker_install() {
    installer=$1

    # default to ohmyssh images
    if [[ ! $installer = *"/"* ]]; then
      installer=ohmyssh/$installer
    fi

    docker run --rm -v /opt/bin:/target $installer
    docker rmi $installer
}

# sfs creates a temporary directory and mounts a remote filesystem to it. Usage: sfs core@ares.unchain.io
sfs() {
    mkdir /tmp/$1
    sshfs $1:/ /tmp/$1

    # Replace dolphin with the file explorer you use
    nohup dolphin /tmp/$1 &>/dev/null &
}

ns() {
    nix develop $@ --command zsh
}

# sin adds a new entry to your ssh config file. Usage: sin ares core ares.unchain.io
sin() {
cat << EOF >> ~/.ssh/config

Host $1
    User $2
    HostName $3

EOF
}

mvv() { mkdir -p "${@: -1}" && mv "$@"; }

my-backward-delete-word () {
    local WORDCHARS='~!#$%^&*(){}[]<>?+;'
    zle backward-delete-word
}
zle -N my-backward-delete-word

tcsh-backward-delete-word () {
  local WORDCHARS="${WORDCHARS:s#/#}"
  zle backward-delete-word
} 
zle -N tcsh-backward-delete-word


### Windows WSL2 ###
if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
    # bindkey '^[[3;5~' kill-word

    # if [ ! $VSCODE_GIT_ASKPASS_MAIN ]; then 
    #     bindkey '^H' backward-kill-word
    # fi

    e() {
        explorer.exe $(wslpath -w $*)
    }

    subl() {
        subl.exe $(wp $*)
    }

    wp() {
        wslpath -w $* | sed s/wsl.localhost/wsl$/g
    }

    goland() {
        powershell.exe -Command "cd C:/; goland.cmd $(wp $*)"
    }

    test() {
        cmd.exe /C echo $(wslpath -w . | sed s/wsl.localhost/wsl$/g)
    }

    xc() {
        clip.exe
    }

    xco() {
        powershell.exe -command "Get-Clipboard"
    }
fi
