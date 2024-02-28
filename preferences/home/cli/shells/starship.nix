{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: let
  bg = "bg:#0e1920";
  fg1 = "fg:#6c6c6c";
  fg2 = "fg:#676768";
  promptStyle = "(${fg1} ${bg})";
  separator = "[  ](${fg2} ${bg})";
in {
  programs = {
    starship = {
      enable = true;
      enableTransience = true;
      enableZshIntegration = false;

      settings = {
        add_newline = true;

        format = lib.concatStrings [
          "$os"
          "$shell"
          "$shlvl"
          "$direnv"
          "$nix_shell"
          promptStyle
          "$directory"
          promptStyle
          "$git_branch"
          "$git_status"
          promptStyle
          "$sudo"
          promptStyle
          "[](fg:#0e1920)"
          "$fill"
          "[](fg:#0e1920)$nodejs"
          "$python"
          "$rust"
          "$golang"
          "$cmd_duration"
          "$time\n"
          "$character"
        ];

        fill = {
          symbol = " ";
        };

        continuation_prompt = "▶▶ ";
        palette = "noctis";
        palettes = {
          noctis = {
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
          format = "[ $symbol]($style)";
          style = "bg:os_bg fg:os_fg";

          symbols.NixOS = "";
          symbols.Windows = "";
        };
        directory = {
          style = "bg:dir_bg fg:dir_fg";
          format = "${separator}[ $path]($style)";
          truncate_to_repo = false;
          use_os_path_sep = false;
          truncation_length = 33333;

          # substitutions = {
          #   Documents = "󰈙 ";
          #   Downloads = " ";
          #   Music = " ";
          #   Pictures = " ";
          # };
        };

        sudo = {
          disabled = false;
        };

        # direnv = {
        #   disabled = false;
        # };

        shell = {
          disabled = false;
          style = "bg:os_bg dimmed fg:nix_fg";
          fish_indicator = "󰈺";
          format = "${separator}[$indicator]($style)";
        };

        shlvl = {
          disabled = false;
          format = "${separator}[↕$shlvl]($style)";
          style = "bg:os_bg dimmed fg:nix_fg";
        };

        nix_shell = {
          disabled = false;
          symbol = "  ";
          format = "${separator}[$symbol$state]($style)";
          impure_msg = "[💩](bg:os_bg bold red)";
          style = "bg:os_bg dimmed fg:nix_fg";
        };

        git_branch = {
          symbol = "";
          style = "fg:#008700 bg:#0e1920";
          format = "${separator}[$symbol $branch]($style)";
        };

        git_status = {
          style = "fg:#008700 bg:#0e1920";
          format = "[($staged$modified$stashed)]($style)";
          staged = " $count";
          modified = " $count";
          stashed = " $count";
        };

        nodejs = {
          symbol = "";
          style = "fg:#769ff0 bg:#0e1920";
          format = "${separator}[$symbol ($version)]($style)";
        };

        rust = {
          symbol = "";
          style = "fg:#769ff0 bg:#0e1920";
          format = "${separator}[$symbol ($version)]($style)";
        };

        golang = {
          symbol = "";
          style = "fg:#769ff0 bg:#0e1920";
          format = "${separator}[$symbol ($version)]($style)";
        };

        php = {
          symbol = "";
          style = "fg:#769ff0 bg:#0e1920";
          format = "${separator}[$symbol ($version)]]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          style = "fg:#a0a9cb bg:#0e1920";
          format = "[  $time ]($style)";
        };

        python = {
          style = "bg:node_bg";
          format = "${separator}[$symbol ($version)]($style)";
        };
      };
    };
  };
}
