{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/ac718d02867a84b42522a0ece52d841188208f2c";
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

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.flake-utils.follows = "flake-utils";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.inputs.flake-compat.follows = "flake-compat";
    nix-alien.inputs.flake-utils.follows = "flake-utils";
    nix-alien.inputs.nix-index-database.follows = "nix-index-database";

    golink.url = "github:tailscale/golink/main";
    golink.inputs.nixpkgs.follows = "nixpkgs";
    golink.inputs.flake-utils.follows = "flake-utils";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/latest";
  };

  # nixConfig.extra-trusted-substituters = [ "https://devenv.cachix.org" ];
  # nixConfig.extra-trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
  nixConfig.substituters = [ "https://cache.nixos.org/" "https://devenv.cachix.org/" "https://nixpkgs-python.cachix.org" ];
  nixConfig.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU=" ];

  # nixConfig.extra-trusted-substituters = [ "https://cache.armv7l.xyz" ];
  # nixConfig.extra-trusted-public-keys = [ "cache.armv7l.xyz-1:kBY/eGnBAYiqYfg0fy0inWhshUo+pGFM3Pj7kIkmlBk=" ];

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
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "openssl-1.1.1u"
              ];
            };
            overlays = [
              inputs.nix-alien.overlays.default
              inputs.golink.overlays.${system}.default
              # (inputs.comma.overlays.default)
              (final: prev: {
                rc2nix = inputs.plasma-manager.packages.${system}.rc2nix;
                devenv = inputs.devenv.packages.${system}.devenv;
              })
            ];

          };

          mkHome = { modules ? [ ] }: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = modules ++ [
              nix-index-database.hmModules.nix-index
              ./hosts/minimal/home.nix
              ./hosts/common/home.nix

              # {
              #   programs.nix-index-database.comma.enable = true;
              #   # home.packages = [ inputs.nix-alien.packages.${system}.nix-alien ];
              # }

            ];

            extraSpecialArgs = {
              inherit inputs values;
            };
          };

          mkSystem = { modules ? [ ] }: nixpkgs.lib.nixosSystem {
            inherit pkgs;

            modules = [
              inputs.golink.nixosModules.default
              inputs.sops-nix.nixosModules.sops
              ./hosts/common/configuration.nix
            ] ++ modules;


            # extraSpecialArgs = {
            #   inherit inputs;
            # };
          };

        in
        {
          # packages.test = [ devenv.packages.devenv ];
          # packages.x86_64-linux = [ devenv.packages.x86_64-linux.devenv ];
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

          packages.nixosConfigurations.rpi1 = nixpkgs.lib.nixosSystem {
            system = "armv7l-linux";
            inherit pkgs;
            modules = [
              ./hosts/rpi1/configuration.nix
            ];
          };

          packages.nixosConfigurations.home-nix = mkSystem {
            modules = [
              ./hosts/home-nix/configuration.nix
              inputs.nixos-wsl.nixosModules.wsl
              inputs.vscode-server.nixosModules.default
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
