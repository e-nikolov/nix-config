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

    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, home-manager, ... }:
    let
      id = import ./values.nix { };

      system = "x86_64-linux";

      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ (self: super: { rc2nix = inputs.plasma-manager.packages.${system}.rc2nix; }) ];
      };

      mkHome = { modules ? [ ] }: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./hosts/common.nix
        ] ++ modules;

        # pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
          inherit id;
        };
      };

    in
    {
      # TODO figure out how to do this without hardcoding the username
      homeConfigurations."enikolov@nixps" = mkHome {
        modules = [
          inputs.plasma-manager.homeManagerModules.plasma-manager
          ./hosts/nixps.nix
        ];
      };

      homeConfigurations."enikolov@home-nix" = mkHome {
        modules = [ ./hosts/home-nix.nix ];
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
