{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home/keyd-application-mapper.nix
  ];

  home.packages = [
    pkgs.xkblayout-state
    pkgs.xkb-switch
    pkgs.sxhkd
    pkgs.swhkd
    pkgs.keyd
  ];

  services.keyd-application-mapper = {
    enable = true;
    settings = {
      "*" = {
        # ";" = ''command (xdotool type "$(date +%Y%m%d-%H%M%S)")'';
        # "k" = ''macro(hello)'';
        # "l" = ''command(ydotool type 123)'';
        # "p" = ''command(xdotool type 123)'';
        #   "alt.shift" = "command(/home/enikolov/.local/state/nix/profile/bin/xkblayout-state set +1)";
        #   "alt.1" = "command(/home/enikolov/.local/state/nix/profile/bin/xkblayout-state set +1)";
        #   "alt.2" = "command(echo 123)";
        #   "alt.3" = "macro(123)";
      };

      "microsoft-edge-beta" = {
        "control+alt.left" = "C-S-k";
        "control+alt.right" = "C-S-l";
        "control+alt.s" = "C-S-i";
      };
    };
  };

  services.sxhkd = {
    # package = pkgs.swhkd;
    enable = true;
    keybindings = {
      # "alt + Shift_L" = "setxkbmap -query | grep -q 'bg,us' && setxkbmap us,bg || setxkbmap bg,us";
      # "alt + Shift_L" = "xkb-switch | grep -q 'us' && xkb-switch -s bg || xkb-switch -s us";
      "alt + Shift_L" = "xkblayout-state set +1";
      "ctrl + shift + greater" = "zotero.sh";
      "ctrl + alt + BackSpace" = "kwin_x11 --replace";
    };
  };

  # home.keyboard.options = [
  #   "caps:backspace"
  # ];
}
