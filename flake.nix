{
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = github:Mic92/sops-nix;
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let id = import ./values.nix { };
    in
    {
      homeConfigurations.kdell = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./common.nix ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
          inherit id;
        }; # Pass flake inputs to our config
      };

      virtualisation.docker.enable = true;
      services.tailscale.enable = true;
    };
}
