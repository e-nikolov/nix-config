{ lib, pkgs, config, modulesPath, inputs, values, ... }:
with lib; {
  imports = [
    ../../modules/common/configuration.nix
    inputs.golink.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModules.default
    # "${modulesPath}/profiles/minimal.nix"
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    nativeSystemd = true;
    # Enable native Docker support

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
    # interop.preserveArgvZero = false;
    interop.register = true;
    wslConf.boot.systemd = true;
    wslConf.network.generateResolvConf = true;
    wslConf.network.generateHosts = false;
    startMenuLaunchers = true;
  };
  boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];
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

  nixpkgs.overlays = [
    (final: prev:
      {
        # python3 = prev.python3.override {
        #   packageOverrides = self: super: {
        #     # https://github.com/NixOS/nixpkgs/issues/197408
        #     dbus-next = super.dbus-next.overridePythonAttrs (old: {
        #       checkPhase = builtins.replaceStrings [ "not test_peer_interface" ] [
        #         "not test_peer_interface and not test_tcp_connection_with_forwarding"
        #       ] old.checkPhase;
        #     });
        #   };
        # };
      })
  ];

  services.vscode-server.enable = true;
  services.vscode-server.installPath = "~/.vscode-server-insiders";
  # fonts.fontconfig.enable = pkgs.lib.mkForce true;
  users.users.${values.username}.extraGroups =
    # [ "wheel" "docker" "onepassword-cli" "onepassword" ];
    [ "wheel" "docker" ];
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = [ pkgs.vim pkgs.git pkgs.wget pkgs.pciutils ];
  # environment.noXlibs = false;
  nix.settings.trusted-users = [ "root" values.username ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "23.05";
}
