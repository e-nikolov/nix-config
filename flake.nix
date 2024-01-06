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
    inherit (self) outputs;
    overlays = import ./overlays {inherit inputs outputs;};
  in
    flake-parts.lib.mkFlake {inherit inputs;}
    ({
      withSystem,
      flake-parts-lib,
      ...
    }: {
      imports = [inputs.devenv.flakeModule];

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
        # pkgs-stable = import nixpkgs-stable {
        #   inherit system;
        #   config = {allowUnfree = false;};
        # };
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

          overlays = builtins.attrValues overlays;
          # overlays = import ./overlays { inherit inputs outputs; };
          # overlays = [
          #   (import ./overlays { inherit inputs outputs; }).additions

          #   inputs.nix-alien.overlays.default
          #   inputs.golink.overlay
          #   # inputs.nil.overlays.default
          #   # inputs.nixd.overlays.default

          #   (final: prev: {
          #     # inherit (inputs.nil.packages.${system}) nil;
          #     inherit (inputs.devenv.packages.${system}) devenv;
          #     inherit (inputs.plasma-manager.packages.${system}) rc2nix;
          #   })
          # ];
        };
      in {
        # Provides the pkgs to all flake modules and to withSystem calls
        # _module.args = {inherit pkgs pkgs-stable;};
        _module.args = {inherit pkgs;};

        formatter = system: nixpkgs.legacyPackages.${system}.alejandra;

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

      flake = let
        # inherit (flake-parts-lib) importApply;
        # flakeModules.default = importApply ./flake-module.nix { inherit withSystem; };
        mkHome = {
          system ? "x86_64-linux",
          modules,
          ...
        } @ args:
          withSystem system
          ({
              config,
              inputs',
              pkgs,
              # pkgs-stable,
              ...
            } @ sysargs: let
              pkgs =
                if args ? pkgs
                then args.pkgs
                else sysargs.pkgs;
              modules =
                [
                  # https://github.com/nix-community/home-manager/issues/2033#issuecomment-1848326144
                  {
                    config = {
                      news.display = "silent";
                      news.json = pkgs.lib.mkForce {};
                      news.entries = pkgs.lib.mkForce [];
                    };
                  }

                  ({config, ...}: {
                    nix.package = pkgs.nixFlakes;
                    home.username = values.username;
                    home.homeDirectory = "/home/${values.username}";
                    programs.git.userName = "${values.gitUsername}";
                    programs.git.userEmail = "${values.email}";

                    home.stateVersion = "23.05";
                  })
                ]
                ++ args.modules;
              extraSpecialArgs =
                {
                  inherit inputs outputs values; # pkgs-stable;
                }
                // args.extraSpecialArgs or {};
            in (home-manager.lib.homeManagerConfiguration
              ((pkgs.lib.filterAttrs (k: v: k != "system")
                  args) # "system" is used to set pkgs, but it is not a valid home-manager option
                // {
                  inherit modules pkgs extraSpecialArgs;
                })));

        mkSystem = {
          system ? "x86_64-linux",
          modules,
          ...
        } @ args:
          withSystem system ({
              config,
              inputs',
              pkgs,
              ...
            } @ sysargs: let
              pkgs =
                if args ? pkgs
                then args.pkgs
                else sysargs.pkgs;
              specialArgs =
                {
                  inherit inputs values;
                }
                // args.specialArgs or {};
            in (nixpkgs.lib.nixosSystem
              (args // {inherit pkgs specialArgs;})));
      in {
        inherit overlays;

        homeConfigurations = {
          "${values.username}@home-nix" =
            mkHome {modules = [./hosts/home-nix/home.nix];};
          "${values.username}@nixps" =
            mkHome {modules = [./hosts/nixps/home.nix];};
        };
        nixosConfigurations = {
          home-nix = mkSystem {
            modules = [
              {wsl.defaultUser = values.username;}

              ./hosts/home-nix/configuration.nix
            ];
          };
          nixps = mkSystem {modules = [./hosts/nixps/configuration.nix];};
          rpi1 = mkSystem {
            system = "armv7l-linux";
            modules = [./hosts/rpi1/configuration.nix];
          };
        };
        templates = {
          bare = {
            description = ''
              A bare flake template with a home-manager configuration that only manages itself and the nix package manager
            '';
            path = ./templates/bare;
          };
          minimal = {
            description = ''
              A minimal flake template with a home-manager configuration that adds zsh + customizations
            '';
            path = ./templates/minimal;
          };
          minimal2 = {
            description = ''
              A minimal flake template with a home-manager configuration that adds zsh + customizations
            '';
            path = ./templates/minimal2;
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
    # nil.url = "github:oxalica/nil/main";
    # nixd.url = "github:nix-community/nixd";

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
  };
}
