{ lib, pkgs, config, modulesPath, inputs, values, ... }:
with lib; {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.age.generateKey = true;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  boot.binfmt.emulatedSystems = [ "armv7l-linux" ];
  # boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];

  networking.firewall.checkReversePath = "loose";
  services.tailscale.enable = true;
  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
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

  security.polkit.enable = true;
  #programs._1password-gui.polkitPolicyOwners = [ values.username ];
  # programs._1password.enable = true;
  # programs._1password-gui.enable = true;
  users.users."${values.username}".extraGroups = [ "wheel" "podman" "docker" ];
  programs.git.enable = true;
  environment.systemPackages = [
    # pkgs.bashInteractiveFHS
    pkgs.man-pages
    pkgs.vim
    pkgs.git
    pkgs.wget
    pkgs.golink
    # pkgs.steam-run
    (pkgs.cowsay.overrideAttrs (old: { __contentAddressable = true; }))
  ];
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
