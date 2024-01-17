{ config, pkgs, lib, personal-info, inputs, outputs, ... }:
with lib;
let cfg = config.programs.zsh.extra;
in {
  options.programs.zsh.extra = {
    enable = mkOption {
      default = false;
      description = "Enable zsh extra configuration";
    };
  };

  config.programs.zsh = mkIf cfg.enable {
    enable = mkDefault true;

    initExtraFirst = "";

    initExtra = ''
      _nar() {
        store_path=$1
        cache=$2
        quiet=$3

        store_path=$(echo $store_path | sed -n 's/\/nix\/store\/\([a-zA-Z0-9]*\)-.*/\1/p')
        url="$cache$store_path.narinfo"

        out=$(curl -s $url)
        if [ "$quiet" ]; then
          if [ "$out" = 404 ]; then
            out="(-)"
          else
            out="(+)"
          fi
          echo $url $out
        else
          echo $url
          echo $out
        fi
      }

      alias nar='nix path-info --eval-store auto --store https://cache.nixos.org '
      alias narp='nix build --dry-run 2>&1 '

      f() {
        find $@ -maxdepth 1 -mindepth 1
      }

      _nsf() {
        find /nix/store -maxdepth 1 -mindepth 1 | fzf -m ''${@:+"-q $@"}
      }

      if [[ -d $XDG_STATE_PATH ]]; then
        STATE_PATH=$XDG_STATE_HOME/scripts/nsf
        if [ ! -d $STATE_PATH ]; then
          mkdir -p $STATE_PATH
        fi
      fi

      NSF_PIPE_CONSUMED_STATE_PATH=$STATE_PATH/nsf_pipe_consumed


      NSF_PATHS_STATE_PATH=$STATE_PATH/nsf_paths

      function has_flag() {
        local flag_pattern=$1
        shift

        local positional=()
        while (($#)); do
          opt=$1
          shift

          if [[ $opt =~ ^$flag_pattern ]]; then
            return 1
          fi
        done
      }

      update_paths() {
        _NSF_PATHS=($(find /nix/store -maxdepth 1 -mindepth 1 | fzf -m ''${@:+"-q $@"}))
        if [[ ! -z $_NSF_PATHS ]]; then
          echo "$_NSF_PATHS" >$NSF_PATHS_STATE_PATH
          NSF_PATHS=$_NSF_PATHS
          touch $NSF_PIPE_CONSUMED_STATE_PATH
        fi
      }

      nsf() {
        has_flag "-s" "$@"
        local hf=$?
        if [ -f "$NSF_PIPE_CONSUMED_STATE_PATH" ]; then
          NSF_PIPE_CONSUMED=false
        else
          NSF_PIPE_CONSUMED=true
        fi
        if [ -f "$NSF_PATHS_STATE_PATH" ]; then
          NSF_PATHS=$(cat $NSF_PATHS_STATE_PATH)
        fi

        out_pipe=false
        if [[ ! -t 1 ]]; then
          out_pipe=true
        fi

        if [[ -z $NSF_PATHS || (($out_pipe == false || $NSF_PIPE_CONSUMED == true) && $hf == 0) ]]; then
          # * no out pipe or no past state
          update_paths
        fi

        if [[ $out_pipe == true && $hf == 0 ]]; then
          # * NF_PATHS set && flag -s or out pipe && pipe not consumed
          rm -f $NSF_PIPE_CONSUMED_STATE_PATH
          NSF_PIPE_CONSUMED=true
        fi

        echo $NSF_PATHS
      }

      nsfw() {
        # context "nsfw"
        has_flag "-s" "$@"
        local hf=$?

        if [ -f "$NSF_PATHS_STATE_PATH" ]; then
          NSF_PATHS=$(cat $NSF_PATHS_STATE_PATH)
        fi

        if [[ -z $NSF_PATHS ]]; then
          update_paths
        fi
        if [[ ! -t 1 && $hf == 0 ]]; then
          # * NF_PATHS set && flag -s or out pipe && pipe not consumed
          export NSF_PIPE_CONSUMED=true
        fi

        echo $NSF_PATHS
      }

      context() {
        name="$1 - context"
        if [ -t 0 ]; then
          if [ -t 1 ]; then
            echo "$name: no pipes" >&2
          else
            echo "$name: pipe out only" >&2
          fi
        else
          if [ -t 1 ]; then
            echo "$name: pipe in only" >&2
          else
            echo "$name: pipe in and out" >&2
          fi
        fi
      }

      nar2() {
        # context "nar2"

        local store_paths=()
        while [ $# -gt 0 ]; do
          opt="$1"
          shift

          case $opt in
            -q | --quiet)
              quiet=1
              ;;
            -c | --cache)
              cache="$opt"
              shift
              ;;
            *)
              store_paths+=("$opt")
              ;;
          esac
        done

        if [ ! -t 0 ]; then
          while read line; do
            store_paths+=($(echo $line | tr " " "\n"))
          done
        fi

        if [ ! "$cache" ]; then
          cache="https://cache.nixos.org/"
        fi

        for store_path in "''${store_paths[@]}"; do
          _nar $store_path $cache $quiet
        done 
      }

      # Usage: time-n-cmd TIMES CMD
      #
      time-n-cmd() {
        local times=$1
        local command=$2

        time (
          for run in {1..$times}
          do
            sh -c $command 2>&1 > /dev/null
          done
        )
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

      function mkdest() {
        local positional=()

        while (( $# )); do
          case $1 in
            --)                 shift; positional+=("$*"); break  ;;
            -*)                            ;;
            *)                  positional+=("$1")         ;;
            esac
            shift
        done
        local target="$positional[-1]"
        local dir

        if [[ "$target" =~ '/$' ]]; then
          dir="$target"
        else
          dir="$(dirname "$target")"
        fi

        test -d "$dir" || mkdir -vp "$dir"
      }

      function cp() {
        mkdest "$@"
        command cp "$@"
      }

      function cpp() {
        command cp "$@"
      }

      function mv() {
        mkdest "$@"
        command mv "$@"
      }

      function mvv() {
        command mv "$@"
      }

      function ww() {
        local paths=()
        local lines=()
        while IFS= read -r line; do
          if [[ $line =~ ^/ ]]; then
            paths+=("$line")
          else
            lines+=("$line")
          fi
        done < <(which "$@");

        if [[ ! ''${#paths[@]} -eq 0 ]]; then
          realpath $paths | xargs eza -alh --group-directories-first --color always --icons
        fi

        for i in $lines; do
          echo $i
        done
      } 
      function nd() {
        has_flag "-c|--command" "$@"
        local hf=$?
        if [ $hf = 1 ]; then
          nix develop "$@"
        else
          nix develop "$@" --command zsh
        fi
      }
    '';
  };
}
