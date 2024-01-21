{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  imports = [
    ../../preferences/home/keyboard.nix
    ../../preferences/home/plasma.nix
    ../../preferences/home/cli/term
    ../../preferences/home/vscode
  ];
  # xdg.mimeApps.enable = true; # TODO

  home.packages = [
    (pkgs.makeAutostartItem {
      name = "1password";
      package = pkgs._1password-gui-beta;
    })
    #* Browsers
    pkgs.firefox
    pkgs.microsoft-edge-beta
    pkgs.microsoft-edge
    # pkgs.brave
    # pkgs.vivaldi
    #pkgs.chromium

    #* Messengers
    # pkgs.slack
    # pkgs.viber

    #* Dev
    pkgs.python3
    pkgs.python310Packages.pygments
    pkgs.sublime4
    pkgs.sublime-merge
    #pkgs.libsForQt5.kate
    pkgs.obsidian
    pkgs.zotero

    #* Utils
    pkgs.unrar
    pkgs.ark
    pkgs.parted
    pkgs.xorg.xev

    #* Media
    pkgs.popcorntime
    pkgs.vlc
    pkgs.krita

    #* Office
    pkgs.libreoffice-qt
    pkgs.libsForQt5.kio-gdrive
  ];
  # systemd.user.services = {
  #   _1password_gui_autostart = {
  #     Unit = { Description = "1Password GUI Autostart"; };

  #     Service = {
  #       Environment = "DISPLAY=:0";
  #       ExecStart = "${pkgs._1password-gui}/bin/1password";
  #       Restart = "always";
  #     };
  #     Install.WantedBy = [ "default.target" ];
  #   };
  # };
  programs = {
    ssh = {
      forwardAgent = lib.mkDefault true;
      enable = lib.mkDefault true;
      extraConfig = ''
        Host *
              IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
