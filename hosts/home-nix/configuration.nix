{ lib, pkgs, config, modulesPath, ... }:
with lib; {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "enikolov";
    # startMenuLaunchers = true; 
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
  boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];
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
  services.passSecretService.package = (pkgs.pass-secret-service.overrideAttrs (old: {
    checkInputs = [ ];
  }));
  nixpkgs.overlays = [
    (final: prev: {
      python3 = prev.python3.override {
        packageOverrides = self: super: {
          # https://github.com/NixOS/nixpkgs/issues/197408
          dbus-next = super.dbus-next.overridePythonAttrs (old: {
            checkPhase = builtins.replaceStrings [ "not test_peer_interface" ] [ "not test_peer_interface and not test_tcp_connection_with_forwarding" ] old.checkPhase;
          });
        };
      };
    })
  ];
  #python3Packages = pkgs.python3Packages.override {
  #  overrides = pfinal: pprev: {
  #    dbus-next = pprev.dbus-next.overridePythonAttrs (old: {
  #      # temporary fix for https://github.com/NixOS/nixpkgs/issues/197408
  #      checkPhase = builtins.replaceStrings ["not test_peer_interface"] ["not test_peer_interface and not test_tcp_connection_with_forwarding"] old.checkPhase;
  #    });
  #  };
  #};
  #};


  fonts.fontconfig.enable = pkgs.lib.mkForce true;
  security.polkit.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "enikolov" ];
  # programs._1password-gui.package = (pkgs._1password-gui-beta.overrideAttrs (oldAttrs: {
  #   postInstall = ''
  #     ln -s $out/share/1password/op-ssh-sign $out/bin/op-ssh-sign
  #     ln -s $out/share/1password/1Password-KeyringHelper $out/bin/1Password-KeyringHelper
  #   '';
  # }));
  # security.pam.services.kwallet = {
  #   name = "kwallet";
  #   enableKwallet = true;
  # };

  programs.mosh.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.enikolov.extraGroups = [ "wheel" "docker" "onepassword-cli" "onepassword" ];
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
  # Enable nix flakes
  nix.settings.trusted-users = [ "root" "enikolov" ];
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "22.05";
}
