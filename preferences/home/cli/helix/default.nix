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
      theme = "catppuccin_mocha";
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

      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
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
