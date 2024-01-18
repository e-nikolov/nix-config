{
  lib,
  pkgs,
  config,
  modulesPath,
  inputs,
  me,
  ...
}: let
  # Only enable auto upgrade if current config came from a clean tree
  # This avoids accidental auto-upgrades when working locally.
  # isClean = inputs.self ? rev;
  isClean = true;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-ld.nixosModules.nix-ld

    ../../modules/nixos/nordvpn
  ];

  networking.firewall.checkReversePath = "loose";
  services.tailscale.enable = true;
  services.nordvpn.enable = true;
  services.openssh.enable = true;

  documentation.dev.enable = true;
  documentation.man.enable = true;
  documentation.enable = true;
  documentation.man.mandoc.enable = true;
  documentation.man.man-db.enable = false;
  programs.ssh.enableAskPassword = true;
  programs.git.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    # enableBashCompletion = true;
  };
  programs.bash = {
    # vteIntegration = true;
    # blesh.enable = true; # bugged
  };
  users.defaultUserShell = pkgs.zsh;
  programs.mosh.enable = true;

  boot.binfmt.emulatedSystems = ["armv7l-linux" "aarch64-linux"];
  programs.nix-ld.enable = true;
  programs.nix-ld.package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    libGL
    libappindicator-gtk3
    libdrm
    libglvnd
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    openssl
    pango
    pipewire
    stdenv.cc.cc
    systemd
    vulkan-loader
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    zlib
  ];
  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.dockerCompat = true;
  # virtualisation.podman.defaultNetwork.dnsname.enable = true;

  system.autoUpgrade = {
    enable = isClean;
    flake = me.flake-url;
    flags = [
      "-L" # print build logs
      "--refresh"
    ];
    dates = "09:30";
    # randomizedDelaySec = "45min";
  };
  systemd.services.nixos-upgrade = lib.mkIf config.system.autoUpgrade.enable {
    # path = [pkgs.git pkgs.openssh];
    serviceConfig.ExecCondition =
      lib.getExe
      (pkgs.writeShellScriptBin "check-date" ''
        lastModified() {
          nix flake metadata "$1" --refresh --json | ${
          lib.getExe pkgs.jq
        } '.lastModified'
        }
        echo remote flake: $(lastModified "${config.system.autoUpgrade.flake}")
        echo local flake: $(lastModified "${me.flake-path}")
        test "$(lastModified "${config.system.autoUpgrade.flake}")"  -gt "$(lastModified "${me.flake-path}")"
      '');
  };

  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.age.generateKey = true;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=30
  '';
  security.polkit.enable = true;
  security.pam.services.kwallet.enableKwallet = true;

  users.users.${me.username}.extraGroups = ["wheel" "podman" "docker" "nordvpn" "onepassword" "onepassword-cli"];

  environment.systemPackages = [
    # pkgs.bashInteractiveFHS
    pkgs.nixUnstable
    pkgs.wgnord
    pkgs.neovim
    pkgs.nordvpn
    pkgs.man-pages
    pkgs.vim
    pkgs.git
    pkgs.wget
    pkgs.golink
    pkgs.pciutils
    pkgs.micro

    # pkgs.steam-run
    (pkgs.cowsay.overrideAttrs (old: {__contentAddressable = true;}))
  ];

  nix = {
    package = lib.mkDefault pkgs.nixUnstable;
    gc.automatic = true;
    nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
        "repl-flake"
        "ca-derivations"
        "auto-allocate-uids"
      ];

      keep-derivations = lib.mkDefault true;
      keep-outputs = lib.mkDefault true;
      auto-optimise-store = lib.mkDefault true;
      use-xdg-base-directories = lib.mkDefault true;
      log-lines = lib.mkDefault 20;
      show-trace = lib.mkDefault true;

      trusted-users = ["root" "@wheel"];
    };
  };
}
