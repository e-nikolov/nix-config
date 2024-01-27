{
  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs: let
    me = {
      username = "enikolov";
      fullName = "Emil Nikolov";
      email = "emil.e.nikolov@gmail.com";
      flake-path = "/home/${me.username}/nix-config";
      flake-url = "github:e-nikolov/nix-config/master";
      flake-repo = "https://github.com/e-nikolov/nix-config";
    };

    inherit (flake-parts.lib) importApply mkFlake;

    flakeModules = {
      default.imports = [
        (importApply ./lib {inherit inputs;})
        (importApply ./overlays {inherit inputs;})
      ];
    };
  in
    mkFlake {inherit inputs;} {
      debug = true;
      _module.args.me = me;
      _module.args.self = inputs.self;

      imports = (inputs.nixpkgs.lib.attrValues flakeModules) ++ [inputs.devenv.flakeModule ./pre-commit-hooks.nix];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
        "armv7l-linux"
      ];
      perSystem = {
        config,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake ";
          packages = [
            pkgs.alejandra
            pkgs.nodePackages.prettier
            pkgs.home-manager
            pkgs.nixUnstable
            pkgs.zsh
            pkgs.git

            pkgs.sops
            pkgs.gnupg
            pkgs.age
          ];
          DIRENV_LOG_FORMAT = "";
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
      ## * End of perSystem() ##

      flake = {
        inherit me flakeModules;

        homeConfigurations = {
          "${me.username}@home-nix" = self.lib.mkHome {
            modules = [./hosts/home-nix/home.nix];
          };
          "${me.username}@nixps" = self.lib.mkHome {
            modules = [./hosts/nixps/home.nix];
          };
          test = self.lib.mkHome {
            modules = [];
          };
        };

        nixosConfigurations = {
          home-nix = self.lib.mkSystem {
            modules = [./hosts/home-nix/configuration.nix];
          };
          nixps = self.lib.mkSystem {
            modules = [./hosts/nixps/configuration.nix];
          };
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

  nixConfig = {
    extra-substituters = ["https://e-nikolov-nix-config.cachix.org" "https://helix.cachix.org"];
    extra-trusted-public-keys = [
      "e-nikolov-nix-config.cachix.org-1:0Y02be6fZwhgvQjyzN3w+bNc5k3Uaz6kXLbAiO0bkO4="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    # nil.url = "github:oxalica/nil/main";
    # nil.inputs.nixpkgs.follows = "nixpkgs";
    # nil.inputs.flake-utils.follows = "flake-utils";
    # nixd.url = "github:nix-community/nixd";

    code-insiders = {
      url = "github:e-nikolov/code-insiders-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-index-database = {
      url = "github:nix-community/nix-index-database/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nix-index-database.follows = "nix-index-database";
      };
    };

    golink = {
      url = "github:tailscale/golink/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-ld = {
      url = "github:Mic92/nix-ld/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    # nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
}
