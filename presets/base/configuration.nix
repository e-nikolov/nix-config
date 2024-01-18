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
  isClean = inputs.self ? rev;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-ld.nixosModules.nix-ld

    ../../modules/nixos/nordvpn
  ];

  networking.firewall.checkReversePath = "loose";
  services = {
    tailscale.enable = true;
    nordvpn.enable = true;
    openssh.enable = true;
  };

  documentation = {
    enable = true;
    dev.enable = true;
    man = {
      enable = true;
      mandoc.enable = true;
      man-db.enable = false;
    };
  };

  programs = {
    ssh.enableAskPassword = true;

    git.enable = true;
    zsh = {
      enable = true;
      enableCompletion = false;
      # enableBashCompletion = true;
    };
    bash = {
      # vteIntegration = true;
      # blesh.enable = true; # bugged
    };
    mosh.enable = true;
    nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
      libraries = with pkgs; [
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
    };
  };
  users.defaultUserShell = pkgs.zsh;

  boot.binfmt.emulatedSystems = ["armv7l-linux" "aarch64-linux"];
  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
      # defaultNetwork.dnsname.enable = true;
    };
  };

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

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
    };
  };

  security = {
    sudo.extraConfig = ''
      Defaults        timestamp_timeout=30
    '';
    polkit.enable = true;
    pam.services.kwallet.enableKwallet = true;
  };

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
