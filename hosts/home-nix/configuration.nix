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
    ../../presets/base/configuration.nix
    inputs.golink.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "home-nix";

  sops.secrets."services/golink/auth_key" = {
    owner = config.services.golink.user;
  };
  services.golink = {
    enable = true;
    tailscaleAuthKeyFile = "/run/secrets/services/golink/auth_key";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = [pkgs.obsidian];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "23.05";
}
