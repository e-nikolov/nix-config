{
  config,
  pkgs,
  lib,
  inputs,
  ...
} @ args: {
  home.packages = [pkgs.zsh-powerlevel10k];

  programs.zsh = {
    initExtraFirst = lib.mkOrder 2 ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    plugins = [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = "p10k.zsh";
        name = "powerlevel10k-config";
        src = ./.;
      }
    ];

    initExtra = lib.mkAfter ''
      ### Theme ###

      function prompt_shell_level() {
          local lvl=$SHLVL

          if [[ $lvl -gt 1 ]]; then
              p10k segment -f blue -i '🐚🪜' -t "$SHLVL"
          fi
      }

      typeset -g PROMPT_EOL_MARK=""
      typeset -g POWERLEVEL9K_TERM_SHELL_INTEGRATION=true
      typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context root_indicator direnv shell_level nix_shell dir vcs newline prompt_char)
      typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(newline status command_execution_time background_jobs history  goenv nodeenv fvm kubecontext terraform nordvpn nnn midnight_commander time go_version newline)
      typeset -g POWERLEVEL9K_DIR_FOREGROUND=14
      typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=14
      typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=3
      typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=28
      typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=28
      typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=28
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=28
      typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=28
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=28
      typeset -g POWERLEVEL9K_BACKGROUND=#0e1920
      # typeset -g POWERLEVEL9K_BACKGROUND=#1d3541
      typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|make'

      # p10k reload
      # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time direnv kubecontext context nix_shell time)
    '';
  };
}
