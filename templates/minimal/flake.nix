{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-config-minimal.url = "github:e-nikolov/nix-config/master?dir=modules/minimal";

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    home-manager,
    nix-config-minimal,
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
          (self: super: {
          })
        ];
      };

      mkHome = {modules, ...} @ args: let
        modules =
          [
            nix-config-minimal.homeModule
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
            home.username = "{{username}}";
            home.homeDirectory = "{{homedir}}";

            home.packages = [
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
            home.stateVersion = "23.05";
          }
        ];
      };
    });
}
