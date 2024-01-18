{inputs, ...} @ localFlake: {
  lib,
  config,
  getSystem,
  ...
} @ flake: let
  # importPkgs = path:
  #   import path (cfg.args
  #     // {
  #       inherit system;
  #       overlays = [inputs.self.overlays.default] ++ cfg.args.overlays;
  #     });
  overlays = [
    inputs.nix-alien.overlays.default
    inputs.golink.overlay
    inputs.code-insiders.overlays.default
    inputs.helix.overlays.default
    # inputs.nil.overlays.default

    (final: prev:
      {
        inherit (inputs.devenv.packages.${final.system}) devenv;
        inherit (inputs.plasma-manager.packages.${final.system}) rc2nix;
        stable = import inputs.nixpkgs-stable {
          inherit (final) system;
          config.allowUnfree = true;
        };
      }
      // import ../packages {pkgs = final;})
  ];
in {
  flake.overlays.default = final: prev: lib.composeManyExtensions overlays final prev;

  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [inputs.self.overlays.default];

      config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        allowInsecurePredicate = pkg:
          builtins.elem (lib.getName pkg) [
            "openssl"
            # obsidian https://github.com/NixOS/nixpkgs/issues/273611
            "electron"
          ];
      };
    };
  };
}
