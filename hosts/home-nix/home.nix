{
  config,
  pkgs,
  inputs,
  self,
  ...
}: let
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
  imports = [../../modules/common/home.nix];

  systemd.user.services = {
    _1password_gui_autostart = {
      Unit = {
        Description = "1Password GUI Autostart";
        # After = [ "network.target" ];
      };

      Service = {
        Environment = "DISPLAY=:0";
        ExecStartPre = "${pkgs.coreutils-full}/bin/chmod 700 /run/user/1000";
        ExecStart = "${pkgs._1password-gui}/bin/1password";
        Restart = "always";
      };
      # Install.WantedBy = [ "graphical-session.target" ];
      # Install.WantedBy = [ "graphical.target" ];
      # Install.WantedBy = [ "multi-user.target" ];
      Install.WantedBy = ["default.target"];
    };
  };

  home.packages = [
    # _1password_autostart
    # pkgs.libsForQt5.kate
    # pkgs.emanote
  ];

  programs.bash.initExtra = ''
    source ~/nix-config/dotfiles/.bashrc
  '';

  programs.zsh = {
    initExtra = ''
      ### Windows WSL2 ###
      if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
        keep_current_path() {
          printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
        }
        precmd_functions+=(keep_current_path)

        e() {
          explorer.exe $(wslpath -w $*)
        }

        subl() {
          subl.exe $(wp $*)
        }

        wp() {
          wslpath -w $* | sed s/wsl.localhost/wsl$/g
        }
      fi
    '';
  };
}
