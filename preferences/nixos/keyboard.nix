{
  pkgs,
  lib,
  self,
  inputs,
  personal-info,
  ...
}: {
  imports = [
    ../../modules/nixos/keyd
  ];

  custom.services.keyd.enable = true;
  custom.services.keyd.keyboards = {
    default = {
      ids = ["*"];
      settings = {
        main = {
          capslock = "overload(control, esc)";
          # o = "macro(321)";
          # n = "command(ydotool type 321)";
        };

        control = {};
        alt = {};
        "control+alt" = {};

        # alt = {
        #   "4" = "command(/home/enikolov/.local/state/nix/profile/bin/xkblayout-state set +1)";
        #   "5" = "macro(321)";
        # };

        # "microsoft-edge-beta" = {
        #   "ctrl.alt.left" = "C-S-k";
        #   "ctrl.alt.right" = "C-S-l";
        # };
      };
    };
    # externalKeyboard = {
    #   ids = [ "1ea7:0907" ];
    #   settings = {
    #     main = {
    #       esc = capslock;
    #     };
    #   };
    # };
  };

  users.users.${personal-info.username} = {
    isNormalUser = true;
    extraGroups = [
      "keyd"
    ];
  };
}
