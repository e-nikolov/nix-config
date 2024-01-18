{
  lib,
  pkgs,
  config,
  modulesPath,
  inputs,
  me,
  ...
}: {
  imports = [
    ../../preferences/nixos/display
    ../../preferences/nixos/audio.nix
    ../../preferences/nixos/touchpad.nix
    ../../preferences/nixos/keyboard.nix
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["kde"];
      hyprland.default = ["kde" "hyprland"];
    };

    extraPortals = [pkgs.xdg-desktop-portal-kde];
  };

  environment.systemPackages = [pkgs.konsole pkgs.libsForQt5.kcalc];

  programs = {
    dconf.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [me.username];
      package = pkgs._1password-gui-beta;
    };
  };

  services.upower.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
}
