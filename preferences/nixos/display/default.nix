{
  pkgs,
  lib,
  self,
  inputs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./x11.nix
    ./nvidia.nix
    ./wayland.nix
    ./wm/hyprland
    ./wm/plasma
  ];

  boot.plymouth.enable = true;

  hardware = {
    # smooth backlight control
    brillo.enable = true;
    opengl = {
      enable = true;
      # extraPackages = with pkgs; [
      #   libva
      #   vaapiVdpau
      #   libvdpau-va-gl
      # ];
      # extraPackages32 = with pkgs.pkgsi686Linux; [
      #   vaapiVdpau
      #   libvdpau-va-gl
      # ];
    };
  };
}
