{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  imports = [./languages.nix];

  programs.helix = {
    enable = true;
    extraPackages = [
      pkgs.marksman
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.typescript
    ];

    package = inputs.helix.packages.${pkgs.system}.default.overrideAttrs (old: {
      makeWrapperArgs = with pkgs;
        old.makeWrapperArgs
        or []
        ++ [
          "--suffix"
          "PATH"
          ":"
          (lib.makeBinPath [
            clang-tools
            marksman
            nil
            nodePackages.bash-language-server
            nodePackages.vscode-css-languageserver-bin
            nodePackages.vscode-langservers-extracted
            shellcheck
          ])
        ];
    });
    settings = {
      # theme = "catppuccin_mocha";
      theme = "onedark";
      editor = {
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        statusline.center = ["position-percentage"];
        true-color = true;
        whitespace.characters = {
          newline = "↴";
          tab = "⇥";
        };
      };
      keys = let
        common = {
          C-r = "command_palette";
          # "^[[Z" = "redo";
          C-s = ":w";
          C-z = "undo";
          C-A-z = "redo";
          C-c = ":clipboard-yank";
          S-home = "extend_to_line_start";
          S-end = ["extend_to_line_end" "extend_char_right"];
          S-up = ["extend_line_up" "extend_char_left"];
          S-left = "extend_char_left";
          S-right = "extend_char_right";
          S-down = "extend_line_down";
          C-A-up = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
          C-A-down = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          C-d = ["extend_to_line_bounds" "yank" "paste_after"];
          C-A-v = ":clipboard-paste-replace";
          C-a = "select_all";
          C-q = "hover";
          C-x = [":clipboard-yank" "delete_selection_noyank"];
          C-A-l = ":format";
          "^" = {
            "[" = {
              "[" = {
                "Z" = "redo";
              };
            };
          };
          del = "delete_selection_noyank";
          backspace = "delete_char_backward";
          # C-v = ":clipboard-paste-after";
        };
      in {
        select = {
        };
        insert =
          common
          // {
          };
        normal =
          common
          // {
            # C-S = {
            #   C = ":clipboard-yank";
            #   Z = "redo";
            #   up = "move_line_up";
            #   down = "move_line_down";
            # };

            # S = {
            #   up = "extend_line_up";
            #   down = "extend_line_down";
            # };
            # C = {
            #   z = "undo";
            #   A = "select_all";
            # };

            space.u = {
              f = ":format"; # format using LSP formatter
              w = ":set whitespace.render all";
              W = ":set whitespace.render none";
            };
          };
      };
    };
    # settings = {
    #   theme = "onedark";
    #   editor = {
    #     lsp.display-messages = true;
    #     cursor-shape = {
    #       insert = "bar";
    #       normal = "block";
    #       select = "underline";
    #     };
    #   };
    #   keys.normal = {
    #     space.space = "file_picker";
    #     # space.w = ":w";
    #     # space.q = ":q";
    #     esc = [ "collapse_selection" "keep_primary_selection" ];
    #   };
    # };
    # themes = {
    #   base16 = let
    #     transparent = "none";
    #     gray = "#665c54";
    #     dark-gray = "#3c3836";
    #     white = "#fbf1c7";
    #     black = "#282828";
    #     red = "#fb4934";
    #     green = "#b8bb26";
    #     yellow = "#fabd2f";
    #     orange = "#fe8019";
    #     blue = "#83a598";
    #     magenta = "#d3869b";
    #     cyan = "#8ec07c";
    #   in {
    #     "ui.menu" = transparent;
    #     "ui.menu.selected" = {modifiers = ["reversed"];};
    #     "ui.linenr" = {
    #       fg = gray;
    #       bg = dark-gray;
    #     };
    #     "ui.popup" = {modifiers = ["reversed"];};
    #     "ui.linenr.selected" = {
    #       fg = white;
    #       bg = black;
    #       modifiers = ["bold"];
    #     };
    #     "ui.selection" = {
    #       fg = black;
    #       bg = blue;
    #     };
    #     "ui.selection.primary" = {modifiers = ["reversed"];};
    #     "comment" = {fg = gray;};
    #     "ui.statusline" = {
    #       fg = white;
    #       bg = dark-gray;
    #     };
    #     "ui.statusline.inactive" = {
    #       fg = dark-gray;
    #       bg = white;
    #     };
    #     "ui.help" = {
    #       fg = dark-gray;
    #       bg = white;
    #     };
    #     "ui.cursor" = {modifiers = ["reversed"];};
    #     "variable" = red;
    #     "variable.builtin" = orange;
    #     "constant.numeric" = orange;
    #     "constant" = orange;
    #     "attributes" = yellow;
    #     "type" = yellow;
    #     "ui.cursor.match" = {
    #       fg = yellow;
    #       modifiers = ["underlined"];
    #     };
    #     "string" = green;
    #     "variable.other.member" = red;
    #     "constant.character.escape" = cyan;
    #     "function" = blue;
    #     "constructor" = blue;
    #     "special" = blue;
    #     "keyword" = magenta;
    #     "label" = magenta;
    #     "namespace" = blue;
    #     "diff.plus" = green;
    #     "diff.delta" = yellow;
    #     "diff.minus" = red;
    #     "diagnostic" = {modifiers = ["underlined"];};
    #     "ui.gutter" = {bg = black;};
    #     "info" = blue;
    #     "hint" = dark-gray;
    #     "debug" = dark-gray;
    #     "warning" = yellow;
    #     "error" = red;
    #   };
    # };
  };
}
