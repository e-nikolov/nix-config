{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: let
  inherit (lib) mkAfter;
in {
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh.initExtra = mkAfter ''
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
      __zoxide_z () {
        if [[ "$#" -eq 0 ]]
        then
                __zoxide_cd ~
        elif [[ "$#" -eq 1 ]] && {
                        [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]
                }
        then
                __zoxide_cd "$1"
        else
                \builtin local result
                result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")"  && __zoxide_cd "''${result}"
        fi
      }


      # __zoxide_z () {
      #   if [[ "$#" -eq 0 ]]
      #   then
      #           __zoxide_cd ~
      #   elif [[ "$#" -eq 1 ]] && {
      #                   [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]
      #           }
      #   then
      #           __zoxide_cd "$1"
      #   elif [[ "$@[-1]" == "''${__zoxide_z_prefix}"?* ]]
      #   then
      #           \builtin local result="''${@[-1]}"
      #           __zoxide_cd "''${result:''${#__zoxide_z_prefix}}"
      #   else
      #           \builtin local result
      #           result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")"  && __zoxide_cd "''${result}"
      #   fi
      # }
    '';
  };
}
