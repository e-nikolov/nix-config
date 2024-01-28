{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  config.programs.zsh = {
    history = {
      size = 100000;
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
      setopt NO_LIST_BEEP
      setopt LIST_PACKED


      setopt GLOB_DOTS      # no special treatment for file names with a leading dot
      setopt NO_AUTO_MENU   # require an extra TAB press to open the completion menu
      setopt ALWAYS_TO_END
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt NO_AUTO_REMOVE_SLASH
      setopt NO_BEEP
      setopt NO_BG_NICE
      setopt C_BASES
      setopt EXTENDED_HISTORY
      setopt NO_FLOW_CONTROL
      setopt NO_GLOBAL_RCS
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_FCNTL_LOCK
      setopt HIST_FIND_NO_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_IGNORE_SPACE
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_VERIFY
      setopt INTERACTIVE
      setopt INTERACTIVE_COMMENTS
      setopt NO_LIST_TYPES
      setopt PROMPT_SUBST
      setopt SHARE_HISTORY
      setopt INC_APPEND_HISTORY
      setopt TYPESET_SILENT
    '';
  };
}
