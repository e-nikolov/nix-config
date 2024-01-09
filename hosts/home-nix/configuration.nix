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
    ../../modules/common/configuration.nix
    inputs.golink.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    nativeSystemd = true;
    wslConf.boot.systemd = true;
    interop.register = true;
    wslConf.network.generateResolvConf = true;
    wslConf.network.generateHosts = false;

    # wslConf.automount.root = "/mnt";
    # interop.preserveArgvZero = false;
    # wslConf.interop.enabled = true;
    # wslConf.interop.appendWindowsPath = true;
  };
  security.sudo.wheelNeedsPassword = true;

  networking.hostName = "home-nix";

  sops.secrets."services/golink/auth_key" = {
    owner = config.services.golink.user;
  };
  services.golink = {
    enable = true;
    tailscaleAuthKeyFile = "/run/secrets/services/golink/auth_key";
  };

  # services.passSecretService.enable = true;
  # services.passSecretService.package =
  # pkgs.pass-secret-service.overrideAttrs (old: { checkInputs = [ ]; });

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = [pkgs.vim pkgs.git pkgs.wget pkgs.pciutils pkgs.konsole pkgs.obsidian pkgs.nodejs_20];
  # environment.noXlibs = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "23.05";
}
