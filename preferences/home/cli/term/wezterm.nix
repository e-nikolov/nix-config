{
  config,
  pkgs,
  me,
  inputs,
  lib,
  ...
}: let
  noctis = import ./themes/noctis.nix;
  inherit (builtins) toString;
in {
  home.activation = {
    copyWezTermConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run cp --update --no-preserve=mode -rf $XDG_CONFIG_HOME/wezterm ${me.flake-path}/preferences/home/cli/term/wezterm
    '';
  };

  programs.wezterm = {
    enable = true;
    colorSchemes = {
      noctis = {
        ansi = [
          noctis.colors.black
          noctis.colors.red
          noctis.colors.green
          noctis.colors.yellow
          "#666042"
          # noctis.colors.blue
          noctis.colors.purple
          noctis.colors.cyan
          noctis.colors.white
        ];
        brights = [
          noctis.colors.brightBlack
          noctis.colors.brightRed
          noctis.colors.brightGreen
          noctis.colors.brightYellow
          noctis.colors.brightBlue
          noctis.colors.brightPurple
          noctis.colors.brightCyan
          noctis.colors.brightWhite
        ];

        # background = noctis.colors.background;
        background = "#1e272d";
        # foreground = noctis.colors.foreground;
        foreground = "#d88a3a";
        cursor_bg = noctis.colors.cursorColor;
        selection_bg = noctis.colors.selectionBackground;
      };
    };
    extraConfig = ''
      local wezterm = require 'wezterm';
      local act = wezterm.action

      return {
          font = wezterm.font('JetBrainsMono Nerd Font Propo'),
          font_size = 12,
          color_scheme = 'noctis',
          default_prog = { 'C:\\WINDOWS\\system32\\wsl.exe', '--cd', '~' },
          audible_bell = 'Disabled',
          cursor_blink_rate = 800,
          cursor_blink_ease_out = 'Linear',
          cursor_blink_ease_in = 'Linear',
          -- cursor_thickness = 0.1,
          line_height = 1.200000,

          keys = {
              {
                  key = 'a',
                  mods = 'CTRL | SHIFT',
                  action = act.ActivateCommandPalette,
              },
              {
                  key = 'w',
                  mods = 'CTRL',
                  action = act.CloseCurrentPane { confirm = false },
              },
              {
                  key = 'b',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[B',
              },
              {
                  key = 'c',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[C',
              },
              {
                  key = 'd',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[D',
              },
              {
                  key = 'e',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[E',
              },
              {
                  key = 'g',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[G',
              },
              {
                  key = 'z',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[Z',
              },
              {
                  key = 's',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[S',
              },
              {
                  key = 'x',
                  mods = 'CTRL | SHIFT',
                  action = act.SendString '\x1b[X',
              },
              {
                  key = 'LeftArrow',
                  mods = 'CTRL | SHIFT',
                  action = wezterm.action.DisableDefaultAssignment,
              },
              {
                  key = 'RightArrow',
                  mods = 'CTRL | SHIFT',
                  action = wezterm.action.DisableDefaultAssignment,
              },
              {
                  key = 'f',
                  mods = 'CTRL',
                  action = act.Search("CurrentSelectionOrEmptyString"),
              },
              {
                  key = 'f',
                  mods = 'CTRL | SHIFT',
                  action = act.ShowTabNavigator,
              },
              {
                  key = 'v',
                  mods = 'CTRL',
                  action = act.PasteFrom 'Clipboard',
              },
              -- { key = '\\', mods = 'ALT', action = wezterm.action.Show },
              -- {
              --     key = 'c',
              --     mods = 'CTRL',
              --     action = act.CopyTo 'Clipboard',
              -- },
              -- {
              --     key = 'LeftArrow',
              --     mods = 'CTRL | ALT',
              --     action = act.,
              -- }

          }
      }

    '';
  };
}
