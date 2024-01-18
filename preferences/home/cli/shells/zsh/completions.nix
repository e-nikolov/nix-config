{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  home.packages = [pkgs.bash-completion pkgs.zsh-completions];
  programs.zsh.completionInit = ''
    eval "$(dircolors -b)"
    export CARAPACE_MATCH=CASE_INSENSITIVE
    export LS_COLORS=$(vivid generate dracula)
    zstyle :compinstall filename '~/.zshrc'

    zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout`
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m' # set descriptions format to enable group support
    zstyle ':completion:*:descriptions' format '[%d]'

    zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS} # set list-colors to enable filename colorizing
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath' # preview directory's content with exa when completing cd
    zstyle ':fzf-tab:*' switch-group ',' '.' # switch group using `,` and `.`
    zstyle ':completion:*' insert-tab pending
    zstyle ':completion:*:default' menu select=1
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
    zstyle ':fzf-tab:*' query-string "" # https://github.com/Aloxaf/fzf-tab/issues/32#issuecomment-1519639800
    zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
    #command -v wg > /dev/null && . ${config.home.profileDirectory}/share/bash-completion/completions/wg
    #command -v wg-quick > /dev/null && . ${config.home.profileDirectory}/share/bash-completion/completions/wg-quick

    zmodload -i zsh/complist

    setopt extendedglob

    autoload -Uz compinit bashcompinit
    # https://gist.github.com/ctechols/ca1035271ad134841284
    if [[ -e ''${ZDOTDIR:-$HOME}/.zcompdump(#qNmh-24) ]]; then
        # .zcompdump exists and is newer than 24 hours
        compinit -C
    else
        # .zcompdump does not exist or is older than 24 hours
        compinit
    fi

    unsetopt extendedglob

    # https://htr3n.github.io/2018/07/faster-zsh/
    # Execute code in the background to not affect the current session
    {
      # Compile zcompdump, if modified, to increase startup speed.
      zcompdump="''${ZDOTDIR:-$HOME}/.zcompdump"
      if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
      fi
    } &!

    bashcompinit
  '';
}
