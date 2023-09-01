{ lib, pkgs, config, modulesPath, inputs, values, ... }:
with lib; {
  # imports = [
  #   "${pkgs.sops-nix}/modules/sops"
  # ];
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.secrets."services/golink/auth_key" = {
    owner = config.services.golink.user;
  };

  sops.age.generateKey = true;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];

  networking.firewall.checkReversePath = "loose";
  services.tailscale.enable = true;
  programs.zsh = {
    # enableBashCompletion = true;
    enable = true;
  };

  security.polkit.enable = true;
  #programs._1password-gui.polkitPolicyOwners = [ values.username ];

  programs.mosh.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  users.defaultUserShell = pkgs.zsh;
  #users.users."${values.username}".extraGroups = [ "wheel" "docker" "onepassword-cli" "onepassword" ];
  programs.git.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    golink
    (cowsay.overrideAttrs
      (old: {
        __contentAddressable = true;
      }))
  ];
  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes repl-flake ca-derivations
  '';

  # https://github.com/nix-community/nix-index/issues/212
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  # https://discourse.nixos.org/t/problems-after-switching-to-flake-system/24093/7
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.gc.automatic = true;
}
