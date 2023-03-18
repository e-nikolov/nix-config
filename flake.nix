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

    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-utils.follows = "flake-utils";
    nixos-wsl.inputs.flake-compat.follows = "flake-compat";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, nix-index-database, home-manager, ... }:
    {
      templates.minimal = {
        description = ''
          Minimal flake
        '';
        path = ./examples/minimal;
      };

      minimal = ./hosts/minimal/home.nix;
    } //
    flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ [ flake-utils.lib.system.armv7l-linux ])
      (system:
        let
          values = import ./values.nix { };

          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = [ (self: super: { rc2nix = inputs.plasma-manager.packages.${system}.rc2nix; }) ];
          };

          mkHome = { modules ? [ ] }: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = modules ++ [
              ./hosts/minimal/home.nix
              ./hosts/common/home.nix
              nix-index-database.hmModules.nix-index
            ];

            extraSpecialArgs = {
              inherit inputs values;
            };
          };

          mkSystem = { modules ? [ ] }: nixpkgs.lib.nixosSystem {
            inherit pkgs;

            modules = [

            ] ++ modules;
          };

        in
        {
          # TODO figure out how to do this without hardcoding the username
          packages.homeConfigurations."enikolov@nixps" = mkHome {
            modules = [
              inputs.plasma-manager.homeManagerModules.plasma-manager
              ./hosts/nixps/home.nix
            ];
          };

          packages.homeConfigurations."enikolov@home-nix" = mkHome {
            modules = [ ./hosts/home-nix/home.nix ];
          };

          packages.nixosConfigurations.nixps = mkSystem {
            modules = [
              ./hosts/nixps/configuration.nix
              inputs.nixos-hardware.nixosModules.dell-xps-15-9560-intel
            ];
          };

          packages.nixosConfigurations.rpi1 = mkSystem {
            modules = [
              ./hosts/rpi1/configuration.nix
            ];
          };

          packages.nixosConfigurations.home-nix = mkSystem {
            modules = [
              ./hosts/home-nix/configuration.nix
              inputs.nixos-wsl.nixosModules.wsl
              inputs.vscode-server.nixosModule
              ({ config, pkgs, ... }: {
                services.vscode-server.enable = true;
              })
            ];
          };

          devShell = pkgs.mkShell
            {
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
        });
}
