{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-index-database = {
      url = "github:nix-community/nix-index-database/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-config = {
      url = "github:e-nikolov/nix-config/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-index-database.follows = "nix-index-database";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    home-manager,
    nix-config,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {allowUnfree = true;};
      };

      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [
          (final: prev: {
          })
        ];
      };

      mkHome = {modules, ...} @ args: let
        modules =
          [
            nix-config.presets.minimal
            ({config, ...}: {
              home.stateVersion = "23.05";
            })
          ]
          ++ args.modules;
        extraSpecialArgs = {inherit inputs;} // args.extraSpecialArgs or {};
      in (home-manager.lib.homeManagerConfiguration (
        args
        // {
          inherit modules pkgs extraSpecialArgs;
        }
      ));
    in {
      packages.homeConfigurations."{{username}}@{{hostname}}" = mkHome {
        modules = [
          {
            home = {
              username = "{{username}}";
              homeDirectory = "{{homedir}}";

              packages = [
                pkgs.hello
              ];

              # This value determines the Home Manager release that your
              # configuration is compatible with. This helps avoid breakage
              # when a new Home Manager release introduces backwards
              # incompatible changes.
              #
              # You can update Home Manager without changing this value. See
              # the Home Manager release notes for a list of state version
              # changes in each release.
              stateVersion = "23.05";
            };
          }
        ];
      };
    });
}
