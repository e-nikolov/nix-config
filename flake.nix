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
    personal-info = {
      flake-path = "~/nix-config/";
      username = "enikolov";
      gitUsername = "e-nikolov";
      email = "emil.e.nikolov@gmail.com";
    };
    default-module = {pkgs, ...}: {
      nix.package = pkgs.nixFlakes;
      home.username = personal-info.username;
      home.homeDirectory = "/home/${personal-info.username}";
      programs.git.userName = personal-info.gitUsername;
      programs.git.userEmail = personal-info.email;

      home.file."nix-config/.tmp/debug.log".text = ''
        ${
          if inputs.self ? rev
          then toString inputs.self.rev
          else "no rev"
        }
        ${inputs.self.outPath}
        ${personal-info.flake-path}
        ${personal-info.email}
      '';

      home.stateVersion = "23.05";
    };

    inherit (self) outputs;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      inherit personal-info;
      imports = [inputs.devenv.flakeModule ./lib];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
        "armv7l-linux"
      ];
      perSystem = {system, ...}: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            nvidia.acceptLicense = true;
            permittedInsecurePackages = [
              # nixos-rebuild switch
              "electron-25.9.0" # obsidian https://github.com/NixOS/nixpkgs/issues/273611
            ];
          };

          overlays = builtins.attrValues self.overlays;
        };
      in {
        # Provides the pkgs to all flake modules and to withSystem calls
        _module.args = {
          inherit pkgs;
        };

        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake ";
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

      flake = {
        overlays = import ./overlays {inherit inputs outputs;};

        homeConfigurations = {
          "${personal-info.username}@home-nix" =
            self.lib.mkHome {modules = [default-module ./hosts/home-nix/home.nix];};
          "${personal-info.username}@nixps" =
            self.lib.mkHome {modules = [default-module ./hosts/nixps/home.nix];};
        };

        nixosConfigurations = {
          home-nix = self.lib.mkSystem {modules = [./hosts/home-nix/configuration.nix];};
          nixps = self.lib.mkSystem {modules = [./hosts/nixps/configuration.nix];};
          rpi1 = self.lib.mkSystem {
            system = "armv7l-linux";
            modules = [./hosts/rpi1/configuration.nix];
          };
        };

        templates = {
          starter = {
            description = ''
              A starter flake template with a home-manager configuration that only manages itself and the nix package manager
            '';
            path = ./templates/starter;
          };
          minimal = {
            description = ''
              A minimal flake template with a home-manager configuration that adds zsh + customizations
            '';
            path = ./templates/minimal;
          };
          full = {
            path = ./.;
            description = ''
              This entire repository, including all of my machines, nixos and home-manager configurations.
              Probably only useful for myself, but others can use it as a reference.
            '';
          };
        };

        modules = import ./modules;
        presets = import ./presets;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    # nil.url = "github:oxalica/nil/main";
    # nixd.url = "github:nix-community/nixd";

    # src = builtins.fetchTarball {
    #   url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #   sha256 = "sha256:023ryfx9zj7d7ghh41xixsz3yyngc2y6znkvfsrswcij67jqm8cd";
    # };
    # vscode-insiders.url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    # vscode-insiders.flake = false;
    code-insiders.url = "github:e-nikolov/code-insiders-flake";
    code-insiders.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    devenv.url = "github:cachix/devenv";

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
    # vscode-server.url = "github:nix-community/nixos-vscode-server";
    # vscode-server.inputs.flake-utils.follows = "flake-utils";
    # vscode-server.inputs.nixpkgs.follows = "nixpkgs";

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
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-ld-rs.url = "github:nix-community/nix-ld-rs";
    nix-ld-rs.inputs.nixpkgs.follows = "nixpkgs";

    # nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";

    nix-gaming.url = "github:fufexan/nix-gaming";
  };
}
