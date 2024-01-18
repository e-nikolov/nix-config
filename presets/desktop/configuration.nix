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

  services.upower.enable = true;
  programs.dconf.enable = true;

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

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [me.username];
  programs._1password-gui.package = pkgs._1password-gui-beta;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
}
