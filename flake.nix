{
  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    nix-index-database,
    home-manager,
    ...
  }: let
    values = import ./values.nix;
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({
      withSystem,
      flake-parts-lib,
      ...
    }: {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
        "armv7l-linux"
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            inputs.nix-alien.overlays.default
            inputs.golink.overlay

            (final: prev: {
              inherit (inputs.plasma-manager.packages.${system}) rc2nix;
              inherit (inputs.devenv.packages.${system}) devenv;
              inherit (pkgs-stable) emanote;
              inherit (pkgs-stable) ripgrep-all;
            })
          ];
        };
      in {
        # Provides the pkgs to all flake modules and to withSystem calls
        _module.args.pkgs = pkgs;

        devShells.default = pkgs.mkShell {
          NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
          nativeBuildInputs = [
            pkgs.home-manager
            pkgs.nix
            pkgs.zsh
            pkgs.git

            pkgs.sops
            pkgs.gnupg
            pkgs.age
          ];
          shellHook = ''
            zsh
          '';
        };
      };
      ## * End of perSystem() ##

      flake = let
        # inherit (flake-parts-lib) importApply;
        # flakeModules.default = importApply ./flake-module.nix { inherit withSystem; };
        mkHome = {
          modules ? [
            {
              # nix.package = pkgs.nix;
              home.username = values.username;
              home.homeDirectory = "/home/${values.username}";
              home.stateVersion = "23.05";
            }
            nix-index-database.hmModules.nix-index
            ./modules/minimal/home.nix
            ./modules/common/home.nix
          ],
          extraModules ? [],
          system ? "x86_64-linux",
        }:
          withSystem system ({
            config,
            inputs',
            pkgs,
            ...
          }: (home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = modules ++ extraModules;

            extraSpecialArgs = {
              inherit inputs values;
            };
          }));

        mkSystem = {
          modules ? [
            inputs.golink.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            ./modules/common/configuration.nix
          ],
          extraModules ? [],
          system ? "x86_64-linux",
          username ? values.username,
        }:
          withSystem system
          ({
            config,
            inputs',
            pkgs,
            ...
          }: (nixpkgs.lib.nixosSystem {
            inherit pkgs;
            modules = modules ++ extraModules;
            specialArgs = {
              inherit inputs values;
            };
          }));
      in {
        homeConfigurations = {
          "${values.username}@nixps" = mkHome {
            extraModules = [
              inputs.plasma-manager.homeManagerModules.plasma-manager
              ./hosts/nixps/home.nix
            ];
          };
          "${values.username}@home-nix" = mkHome {
            extraModules = [./hosts/home-nix/home.nix];
          };
        };
        nixosConfigurations = {
          home-nix = mkSystem {
            extraModules = [
              ./hosts/home-nix/configuration.nix
              inputs.nixos-wsl.nixosModules.wsl
              inputs.vscode-server.nixosModules.default
            ];
          };
          nixps = mkSystem {
            extraModules = [
              ./hosts/nixps/configuration.nix
              inputs.nixos-hardware.nixosModules.dell-xps-15-9560-intel
            ];
          };
          rpi1 = mkSystem {
            system = "armv7l-linux";
            extraModules = [./hosts/rpi1/configuration.nix];
          };
        };
        templates = {
          bare = {
            description = ''
              A bare flake template with a home-manager configuration that only manages itself and the nix package manager
            '';
            path = ./examples/bare;
          };
          minimal = {
            description = ''
              A minimal flake template with a home-manager configuration that adds zsh + customizations
            '';
            path = ./examples/minimal;
          };
          full = {
            path = ./.;
            description = ''
              This entire repository, including all of my machines, nixos and home-manager configurations.
              Probably only useful for myself, but others can use it as a reference.
            '';
          };
        };
        homeModules.bare = ./modules/bare/home.nix;
        homeModules.minimal = ./modules/minimal/home.nix;
        flakeModules.full = self;
      };
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

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
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
}
