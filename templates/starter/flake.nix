{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-substituters = [
      "https://e-nikolov-nix-config.cachix.org"
    ];
    extra-trusted-public-keys = [
      "e-nikolov-nix-config.cachix.org-1:0Y02be6fZwhgvQjyzN3w+bNc5k3Uaz6kXLbAiO0bkO4="
    ];
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    home-manager,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {allowUnfree = true;};
      };

      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [
          (final: prev: {
            inherit (inputs.devenv.packages.${final.system}) devenv;

            # inherit (pkgs-stable) ripgrep-all;
          })
        ];
      };

      mkHome = args:
        home-manager.lib.homeManagerConfiguration ({
            inherit pkgs;

            extraSpecialArgs = {
              inherit inputs;
            };
          }
          // args);
    in {
      packages.homeConfigurations."{{username}}@{{hostname}}" = mkHome {
        modules = [
          # You can include your own customizations on top of the minimal flake inside home.nix
          ./home.nix
          {
            home = {
              username = "{{username}}";
              homeDirectory = "{{homedir}}";

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
