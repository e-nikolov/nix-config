{ config, pkgs, inputs, self, ... }:
let
  # _1password_desktopItem = pkgs.makeDesktopItem {
  #   name = "_1password-gui";
  #   exec = "_1password-gui";
  #   icon = "_1password-gui";
  #   # comment = meta.description;
  #   # genericName = meta.description;
  #   type = "Application";
  #   desktopName = "1Password";
  #   categories = [ "Video" "AudioVideo" ];
  # };
  _1password_autostart = pkgs.makeAutostartItem {
    name = "1password";
    package = pkgs._1password-gui;
  };
in {
  imports = [ ../../presets/base/home.nix ../../presets/wsl/home.nix ];

  systemd.user.services = {
    _1password_gui_autostart = {
      Unit = { Description = "1Password GUI Autostart"; };

      Service = {
        Environment = "DISPLAY=:0";
        ExecStartPre = "${pkgs.coreutils-full}/bin/chmod 700 /run/user/1000";
        ExecStart = "${pkgs._1password-gui}/bin/1password";
        Restart = "always";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
