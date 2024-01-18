{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.zsh-fzf-tab
    # pkgs.stable.ripgrep-all
    # pkgs.ripgrep-all
  ];

  programs.fzf = {
    enable = true;
    historyWidgetOptions = ["--reverse"];
    fileWidgetOptions = [
      "--height=80% --preview='[[ -d {} ]] && eza -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed {} || bat {} --color=always' "
    ];
    # tmux.enableShellIntegration = true;
    # defaultOptions = [ "--ansi" "--height=60%" ];
    defaultOptions = ["--ansi"];
    colors = {
      bg = "#1e1e1e";
      "bg+" = "#1e1e1e";
      fg = "#d4d4d4";
      "fg+" = "#d4d4d4";
    };
  };

  programs.zsh = {
    plugins = [
      {
        file = "fzf-tab.plugin.zsh";
        name = "zsh-fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab/";
      }
    ];

    initExtra = ''
      fzf-process-widget() {
          local pid=( $(ps axww -o pid,user,%cpu,%mem,start,time,command | fzf --layout=reverse --height=10 | sed 's/^ *//' | cut -f1 -d' ') )
          LBUFFER="$LBUFFER$pid"
      }
      zle -N fzf-process-widget

      fzf-port-widget() {
          sudo true
          local port=( $(sudo lsof -i -P -n | fzf | sed 's/^ *//' | tr -s " " | cut -f2 -d' ') )
          LBUFFER="$LBUFFER$port"
      }
      zle -N fzf-port-widget

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

      # Ctrl+G
      bindkey '^G' fzf-file-widget
      bindkey '^P' fzf-process-widget
      bindkey '^O' fzf-port-widget
    '';
  };
}
