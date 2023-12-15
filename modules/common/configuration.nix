{ lib, pkgs, config, modulesPath, inputs, values, ... }:
with lib; {
  imports = [
    inputs.sops-nix.nixosModules.sops

    ../../modules/nixos/nordvpn
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.age.generateKey = true;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];
  # boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];

  programs.nix-ld.enable = true;
  programs.nix-ld.package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
  networking.firewall.checkReversePath = "loose";
  services.tailscale.enable = true;
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

  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.dockerCompat = true;
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      # "--commit-lock-file"
      "-L" # print build logs
    ];
    dates = "08:37";
    # randomizedDelaySec = "45min";
  };
  security.polkit.enable = true;
  security.pam.services.kwallet.enableKwallet = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ values.username ];

  #programs._1password-gui.polkitPolicyOwners = [ values.username ];
  # programs._1password.enable = true;
  # programs._1password-gui.enable = true;
  users.users."${values.username}".extraGroups =
    [ "wheel" "podman" "docker" "nordvpn" ];
  programs.git.enable = true;
  environment.systemPackages = [
    # pkgs.bashInteractiveFHS
    pkgs.wgnord
    pkgs.neovim
    pkgs.nordvpn
    pkgs.man-pages
    pkgs.vim
    pkgs.git
    pkgs.wget
    pkgs.golink

    # pkgs.steam-run
    (pkgs.cowsay.overrideAttrs (old: { __contentAddressable = true; }))
  ];

  services.nordvpn.enable = true;
  documentation.dev.enable = true;
  documentation.man.enable = true;
  documentation.enable = true;
  documentation.man.mandoc.enable = true;
  documentation.man.man-db.enable = false;
  programs.ssh.enableAskPassword = true;
  # Enable nix flakes
  # nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes repl-flake ca-derivations
  '';

  # https://github.com/nix-community/nix-index/issues/212
  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs.outPath}"
    # "nixpkgs-stable=${inputs.nixpkgs-stable.outPath}"
  ];
  # https://discourse.nixos.org/t/problems-after-switching-to-flake-system/24093/7
  # nix.registry.nixpkgs.flake = "${inputs.nixpkgs}";
  # nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.gc.automatic = true;
}
