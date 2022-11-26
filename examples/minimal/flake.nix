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
              # You can remove the line below if you don't want to use the minimal flake from github.com/e-nikolov/nix-config
              nix-config.minimal

              # You can uncomment the line below if you want to switch to a local copy of the minimal flake from github.com/e-nikolov/nix-config
              # ./hosts/minimal/home.nix
            ] ++ modules;

            extraSpecialArgs = {
              inherit inputs;
            };
          };
        in
        {
          packages.homeConfigurations."{{username}}@{{hostname}}" = mkHome {
            modules = [
              # You can include your own customizations on top of the minimal flake inside home.nix
              ./home.nix
            ];
          };
        });
}
