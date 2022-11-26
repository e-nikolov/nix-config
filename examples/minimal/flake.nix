{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-config.url = "github:e-nikolov/nix-config/master";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, home-manager, nix-config, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [ (self: super: { }) ];
          };

          mkHome = { modules ? [ ] }: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              nix-config.minimal
            ] ++ modules;

            extraSpecialArgs = {
              inherit inputs;
            };
          };
        in
        {
          packages.homeConfigurations."<username>@<hostname>" = mkHome {
            modules = [
              ./home.nix
            ];
          };
        });
}
