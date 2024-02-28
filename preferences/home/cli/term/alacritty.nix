{
  config,
  pkgs,
  me,
  inputs,
  lib,
  ...
}: let
  noctis = import ./themes/noctis.nix;
in {
  home.activation = {
    copyAlacrittyConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run cp --no-preserve=mode -f $XDG_CONFIG_HOME/alacritty/alacritty.toml ${me.flake-path}/preferences/home/cli/term/alacritty.toml
    '';
  };
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        inherit (noctis.font) size;
        normal.family = noctis.font.family;
        bold.family = noctis.font.family;
        italic.family = noctis.font.family;
      };

      window = {
        decorations = "Full";
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
        opacity = 0.98;
      };
      shell.program = ''C:\\Program Files\\WSL\\wsl.EXE --cd ~'';

      cursor = {
        style = {
          inherit (noctis.cursor) shape;
          blinking =
            if noctis.cursor.blinking
            then "On"
            else "Off";
        };
      };
      colors = {
        primary = {
          inherit (noctis.colors) background;
          # foreground = noctis.colors.foreground;
          # foreground = "#b78f51";
          foreground = "#d88a3a";
        };
        normal = {
          inherit (noctis.colors) black red green yellow blue cyan white;
          magenta = noctis.colors.purple;
        };
        selection = {
          background = noctis.colors.selectionBackground;
        };
        bright = {
          black = noctis.colors.brightBlack;
          red = noctis.colors.brightRed;
          green = noctis.colors.brightGreen;
          yellow = noctis.colors.brightYellow;
          blue = noctis.colors.brightBlue;
          cyan = noctis.colors.brightCyan;
          white = noctis.colors.brightWhite;
          magenta = noctis.colors.brightPurple;
        };
      };
    };
  };
}
