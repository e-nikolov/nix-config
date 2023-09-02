{
  lib,
  pkgs,
  config,
  modulesPath,
  inputs,
  values,
  ...
}:
with lib; {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = values.username;
    nativeSystemd = true;
    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
    # interop.preserveArgvZero = false;
    interop.register = true;
    wslConf.boot.systemd = true;
    wslConf.network.generateResolvConf = true;
    wslConf.network.generateHosts = false;
    startMenuLaunchers = true;
  };
  boot.binfmt.emulatedSystems = ["armv7l-linux" "aarch64-linux"];
  security.sudo.wheelNeedsPassword = true;

  networking.firewall.checkReversePath = "loose";
  networking.hostName = "home-nix";
  services.tailscale.enable = true;
  # programs.ssh.startAgent = true;
  programs.zsh = {
    # enableBashCompletion = true;
    enable = true;
  };

  services.golink = {
    enable = true;
    tailscaleAuthKeyFile = "/run/secrets/services/golink/auth_key";
  };

  services.passSecretService.enable = true;
  services.passSecretService.package = pkgs.pass-secret-service.overrideAttrs (old: {
    checkInputs = [];
  });
  nixpkgs.overlays = [
    (final: prev: {
      python3 = prev.python3.override {
        packageOverrides = self: super: {
          # https://github.com/NixOS/nixpkgs/issues/197408
          dbus-next = super.dbus-next.overridePythonAttrs (old: {
            checkPhase = builtins.replaceStrings ["not test_peer_interface"] ["not test_peer_interface and not test_tcp_connection_with_forwarding"] old.checkPhase;
          });
        };
      };
    })
  ];

  services.vscode-server.enable = true;
  # fonts.fontconfig.enable = pkgs.lib.mkForce true;
  security.polkit.enable = true;
  programs._1password-gui.polkitPolicyOwners = [values.username];

  programs.mosh.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.${values.username}.extraGroups = ["wheel" "docker" "onepassword-cli" "onepassword"];
  programs.git.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  services.gnome.gnome-keyring.enable = true;
  # services.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    pciutils
    waybar
    dunst
    kmod
    mako
  ];
  nix.settings.trusted-users = ["root" values.username];
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "22.05";
}
