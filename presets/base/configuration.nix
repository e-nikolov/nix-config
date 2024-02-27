{
  lib,
  pkgs,
  config,
  modulesPath,
  options,
  inputs,
  me,
  ...
}: let
  # Only enable auto upgrade if current config came from a clean tree
  # This avoids accidental auto-upgrades when working locally.
  inherit (lib) mkDefault;
  isClean = inputs.self ? rev;
  dockerCompat =
    pkgs.runCommand "${pkgs.podman.pname}-docker-compat-completions-${pkgs.podman.version}"
    {
      outputs = ["out"];
    } ''
      mkdir -p $out/share/zsh/site-functions
      sed s/podman/docker/g ${pkgs.podman}/share/zsh/site-functions/_podman > $out/share/zsh/site-functions/_docker
    '';
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-ld.nixosModules.nix-ld

    ../../modules/nixos/nordvpn
  ];

  networking.firewall.checkReversePath = "loose";
  xdg.portal = {
    enable = true;
    config.common.default = mkDefault "*";
  };
  services = {
    flatpak.enable = true;
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
    _1password.enable = true;
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

    # https://github.com/Mic92/dotfiles/blob/main/nixos/modules/nix-ld.nix
    nix-ld = {
      enable = true;
      package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
      # libraries =
      #   options.programs.nix-ld.libraries.default
      #   ++ [
      #     pkgs.alsa-lib
      #     pkgs.at-spi2-atk
      #     pkgs.at-spi2-core
      #     pkgs.atk
      #     pkgs.cairo
      #     pkgs.glamoroustoolkit.out
      #     pkgs.cups
      #     pkgs.curl
      #     pkgs.dbus
      #     pkgs.expat
      #     pkgs.fontconfig
      #     pkgs.freetype
      #     pkgs.fuse3
      #     pkgs.gdk-pixbuf
      #     pkgs.glib
      #     pkgs.gtk3
      #     pkgs.icu
      #     pkgs.libappindicator-gtk3
      #     pkgs.libgcc.lib
      #     pkgs.libdrm
      #     pkgs.libGL
      #     pkgs.libglvnd
      #     pkgs.libnotify
      #     pkgs.libpulseaudio
      #     pkgs.libunwind
      #     pkgs.libusb1
      #     pkgs.libuuid
      #     pkgs.libxkbcommon
      #     pkgs.libxml2
      #     pkgs.mesa
      #     pkgs.nspr
      #     pkgs.nss_latest.out
      #     pkgs.openssl
      #     pkgs.pango
      #     pkgs.pipewire
      #     pkgs.stdenv.cc.cc
      #     pkgs.systemd
      #     pkgs.vulkan-loader
      #     pkgs.xorg.libX11
      #     pkgs.xorg.libXScrnSaver
      #     pkgs.xorg.libXcomposite
      #     pkgs.xorg.libXcursor
      #     pkgs.xorg.libXdamage
      #     pkgs.xorg.libXext
      #     pkgs.xorg.libXfixes
      #     pkgs.xorg.libXi
      #     pkgs.xorg.libXrandr
      #     pkgs.xorg.libXrender
      #     pkgs.xorg.libXtst
      #     pkgs.xorg.libxcb
      #     pkgs.xorg.libxkbfile
      #     pkgs.xorg.libxshmfence
      #     pkgs.xorg.libXinerama
      #     pkgs.xorg_sys_opengl.out
      #     pkgs.zlib
      #     pkgs.SDL2
      #     pkgs.SDL
      #     pkgs.xorg.libXmu
      #     pkgs.xorg.libSM
      #     pkgs.xorg.libICE
      #     pkgs.dbus-glib
      #     pkgs.alsaLib
      #     pkgs.libva
      #     pkgs.which
      #     pkgs.sqlite
      #     pkgs.pciutils
      #     pkgs.wayland
      #     pkgs.libelf
      #     pkgs.mesa.llvmPackages.llvm.lib
      #     pkgs.mesa.drivers
      #   ];
    };
  };

  users.defaultUserShell = pkgs.zsh;

  boot.binfmt.emulatedSystems = ["armv7l-linux" "aarch64-linux"];
  boot.tmp.cleanOnBoot = true;

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
  environment = {
    pathsToLink = ["/share/zsh"];
    systemPackages = [
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
      dockerCompat

      # pkgs.steam-run
      (pkgs.cowsay.overrideAttrs (old: {__contentAddressable = true;}))
    ];
  };

  nix = {
    package = lib.mkDefault pkgs.nixUnstable;
    gc.automatic = true;
    # nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}"];
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
