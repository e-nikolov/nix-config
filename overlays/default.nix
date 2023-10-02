# This file defines overlays
{ inputs, outputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev:
    import ../pkgs { pkgs = final; } // {
      # formats = prev.formats // import ../pkgs/formats { pkgs = final; };
      # vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins { };
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
    };

  # When applied, the stable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'
  stable = final: _prev: {
    unstable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
