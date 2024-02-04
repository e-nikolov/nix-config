{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: let
  separator = "[ ](fg:#676768 bg:#0e1920)";
in {
  programs = {
    starship = {
      enable = true;
      enableTransience = true;
      enableZshIntegration = false;

      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "[](#0e1920)"
          "$os"
          "$shell"
          "$shlvl"
          "$direnv"
          "$nix_shell"
          "(fg:#6c6c6c bg:#0e1920)"
          "$directory"
          "(fg:#6c6c6c bg:#0e1920)"
          "$git_branch"
          "$git_status"
          "(fg:#6c6c6c bg:#0e1920)"
          "$sudo"
          "(fg:#6c6c6c bg:#0e1920)"
          "[](fg:#0e1920)"
          "$fill"
          "[](fg:#0e1920)$nodejs"
          "$python"
          "$rust"
          "$golang"
          "$cmd_duration"
          "$time\n"
          "$character\n"
        ];

        continuation_prompt = "▶▶ ";
        palette = "tokyonight";
        palettes = {
          tokyonight = {
            git_bg = "#0e1920";
            dir_bg = "#0e1920";
            dir_fg = "#fc874f";
            os_bg = "#0e1920";
            os_fg = "#eeeeee";
            nix_fg = "blue";
            node_bg = "#0e1920";
          };
        };

        os = {
          disabled = false;
          format = "[ $symbol ]($style)${separator}";

          symbols.NixOS = "";
          style = "bg:os_bg fg:os_fg";
        };
        directory = {
          truncate_to_repo = false;
          style = "bg:dir_bg fg:dir_fg";
          format = "[   $path ]($style)${separator}";
          substitutions = {
            Documents = "󰈙 ";
            Downloads = " ";
            Music = " ";
            Pictures = " ";
          };
        };

        # direnv = {
        #   disabled = false;
        # };

        shell = {
          disabled = false;
          style = "bg:os_bg dimmed fg:nix_fg";
          fish_indicator = "󰈺";
          format = "[ $indicator ]($style)${separator}";
        };

        shlvl = {
          format = "[↕$shlvl]($style)${separator}";
          style = "bg:os_bg dimmed fg:nix_fg";
          disabled = false;
        };

        nix_shell = {
          disabled = false;
          symbol = "  ";
          impure_msg = "[💩](bg:os_bg bold red)";
          style = "bg:os_bg dimmed fg:nix_fg";
          format = "[$symbol$state]($style)${separator}";
        };

        git_branch = {
          symbol = "";
          style = "bg:git_bg";
          format = "[[ $symbol $branch ](fg:#008700 bg:#0e1920)]($style)";
        };

        git_status = {
          style = "bg:git_bg";
          format = "[[($staged $modified $stashed )](fg:#008700 bg:#0e1920)]($style)";
          staged = " $count";
          modified = " $count";
          stashed = " $count";
        };

        nodejs = {
          symbol = "";
          style = "bg:node_bg";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#0e1920)]($style)${separator}";
        };

        rust = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#0e1920)]($style)${separator}";
        };

        golang = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#0e1920)]($style)${separator}";
        };

        php = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#0e1920)]($style)${separator}";
        };

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "bg:#1d2230";
          format = "[[  $time ](fg:#a0a9cb bg:#0e1920)]($style)";
        };

        python = {
          style = "bg:node_bg";
          format = "[$symbol$version]($style)";
        };

        fill = {
          symbol = " ";
        };
      };
    };
  };
}
