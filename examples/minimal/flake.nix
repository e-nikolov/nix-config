{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-config.url = "github:e-nikolov/nix-config/master";

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, flake-utils, home-manager, nix-config, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config = { allowUnfree = true; };
          };

          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [
              (self: super: {
                devenv = inputs.devenv.packages.${system}.devenv;
              })
            ];
          };

          mkHome = { modules ? [ ] }: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              inputs.nix-index-database.hmModules.nix-index

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
