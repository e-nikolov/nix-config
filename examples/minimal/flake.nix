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
    devenv.url = "github:cachix/devenv/latest";
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
            # inherit (inputs.devenv.packages.${system}) devenv;
            inherit (pkgs-stable) ripgrep-all;
          })
        ];
      };

      mkHome = {extraModules ? []}:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules =
            [
              inputs.nix-index-database.hmModules.nix-index

              # You can remove the line below if you don't want to use the minimal flake from github.com/e-nikolov/nix-config
              nix-config-minimal.homeModule

              # You can uncomment the line below if you want to switch to a local copy of the minimal flake from github.com/e-nikolov/nix-config
              # ./modules/minimal/home.nix
            ]
            ++ extraModules;

          extraSpecialArgs = {
            inherit inputs;
          };
        };
    in {
      packages.homeConfigurations."{{username}}@{{hostname}}" = mkHome {
        extraModules = [
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
