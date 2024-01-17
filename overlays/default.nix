# This file defines overlays
{ inputs, outputs, ... }: {
  # Third party overlays
  nix-alien = inputs.nix-alien.overlays.default;
  golink = inputs.golink.overlay;
  vscode-insiders = inputs.code-insiders.overlays.default;
  helix = inputs.helix.overlays.default;
  # nil = inputs.nil.overlays.default;
  # nixd = inputs.nixd.overlays.default;

  # This one brings our custom packages from the 'packages' directory
  additions = final: prev:
    import ../packages { pkgs = final; } // {
      # formats = prev.formats // import ../packages/formats { pkgs = final; };
      # vimPlugins = prev.vimPlugins // final.callPackage ../packages/vim-plugins { };
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # inherit (inputs.nil.packages.${system}) nil;
    inherit (inputs.devenv.packages.${final.system}) devenv;
    inherit (inputs.plasma-manager.packages.${final.system}) rc2nix;
  };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  nixpkgs-stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
