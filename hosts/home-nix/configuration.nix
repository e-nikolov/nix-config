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
    ../../presets/base/configuration.nix
    ../../presets/wsl/configuration.nix

    inputs.golink.nixosModules.default
  ];

  networking.hostName = "home-nix";

  # sops.secrets."services/golink/auth_key" = {
  #   owner = config.services.golink.user;
  # };
  # services.golink = {
  #   enable = true;
  #   tailscaleAuthKeyFile = "/run/secrets/services/golink/auth_key";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = [pkgs.obsidian pkgs.mesa pkgs.mesa-demos pkgs.libGL pkgs.xwayland pkgs.firefox pkgs.vlc pkgs.libsForQt5.kate pkgs.libsForQt5.kcalc];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "23.05";
}
