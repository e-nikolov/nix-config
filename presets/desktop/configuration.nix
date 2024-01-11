{
  lib,
  pkgs,
  config,
  modulesPath,
  inputs,
  personal-info,
  ...
}:
with lib; {
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

    extraPortals = [
      pkgs.xdg-desktop-portal-kde
    ];
  };

  environment.systemPackages = [
    pkgs.konsole
    pkgs.libsForQt5.kcalc
  ];
}