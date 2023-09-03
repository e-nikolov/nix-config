{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    home-manager,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (system: {
      templates = {
        minimal = {
          description = ''
            A minimal flake template with a home-manager configuration that adds zsh + customizations
          '';
          path = ../../examples/minimal;
        };
      };
      homeModule = ./home.nix;
    });
}
