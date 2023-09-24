{ outputs, inputs }: {
  # Adds my custom packages
  additions = final: prev:
    import ../pkgs { pkgs = final; } // {
      # formats = prev.formats // import ../pkgs/formats { pkgs = final; };
      # vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins { };
    };
}
