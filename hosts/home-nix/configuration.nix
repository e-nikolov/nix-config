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
    # inputs.vscode-server.nixosModules.default
    # "${modulesPath}/profiles/minimal.nix"
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
  boot.binfmt.emulatedSystems = ["armv7l-linux" "aarch64-linux"];
  security.sudo.wheelNeedsPassword = true;

  networking.firewall.checkReversePath = "loose";
  networking.hostName = "home-nix";
  # programs.ssh.startAgent = true;

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

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     # python3 = prev.python3.override {
  #     #   packageOverrides = self: super: {
  #     #     # https://github.com/NixOS/nixpkgs/issues/197408
  #     #     dbus-next = super.dbus-next.overridePythonAttrs (old: {
  #     #       checkPhase = builtins.replaceStrings [ "not test_peer_interface" ] [
  #     #         "not test_peer_interface and not test_tcp_connection_with_forwarding"
  #     #       ] old.checkPhase;
  #     #     });
  #     #   };
  #     # };
  #   })
  # ];

  # services.vscode-server.enable = true;
  # services.vscode-server.nodejsPackage = pkgs.nodejs_20;
  # services.vscode-server.enableFHS = true;
  # services.vscode-server.installPath = "~/.vscode-server";
  # fonts.fontconfig.enable = pkgs.lib.mkForce true;
  users.users.${personal-info.username}.extraGroups =
    # [ "wheel" "docker" "onepassword-cli" "onepassword" ];
    ["wheel" "docker" "onepassword" "onepassword-cli"];
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = [pkgs.vim pkgs.git pkgs.wget pkgs.pciutils pkgs.konsole pkgs.obsidian pkgs.nodejs_20];
  # environment.noXlibs = false;
  nix.settings.trusted-users = ["root" personal-info.username];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "23.05";
}
