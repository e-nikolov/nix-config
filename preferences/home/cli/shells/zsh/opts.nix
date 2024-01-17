{ config, pkgs, lib, personal-info, inputs, outputs, ... }: {
  config.programs.zsh = {
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
      ignoreSpace = true;
    };

    initExtra = ''
      # Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
      # unsetopt MENU_COMPLETE
      # unsetopt FLOW_CONTROL
      # setopt AUTO_MENU
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END
      setopt NO_LIST_BEEP
      setopt LIST_PACKED


      setopt glob_dots     # no special treatment for file names with a leading dot
      setopt no_auto_menu  # require an extra TAB press to open the completion menu
      setopt alwaystoend
      setopt autocd
      setopt noautomenu
      setopt autopushd
      setopt noautoremoveslash
      setopt nobeep
      setopt nobgnice
      setopt cbases
      setopt extendedhistory
      setopt noflowcontrol
      setopt noglobalrcs
      setopt globdots
      setopt histexpiredupsfirst
      setopt histfcntllock
      setopt histfindnodups
      setopt histignoredups
      setopt histignorespace
      setopt histsavenodups
      setopt histverify
      setopt interactive
      setopt interactivecomments
      setopt nolisttypes
      setopt promptsubst
      setopt sharehistory
      setopt typesetsilent
    '';
  };
}
