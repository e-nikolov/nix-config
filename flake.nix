{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, home-manager, ... }:
    let
      id = import ./values.nix { };

      system = "x86_64-linux";

      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

    in
    {
      # TODO figure out how to do this without hardcoding the username
      homeConfigurations.enikolov = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./common.nix
          ./home.nix
        ];

        # pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
          inherit id;
        };
      };

      devShell = pkgs.mkShell {
        NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
        nativeBuildInputs = with pkgs; [
          home-manager
          nix
          zsh
          git

          sops
          gnupg
          age
        ];
        shellHook = ''
          zsh
        '';
      };
    };
}
