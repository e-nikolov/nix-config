{
  config,
  pkgs,
  id,
  inputs,
  me,
  lib,
  ...
}: let
  promptBGColor = "#0e1920";
  promptBGStyle = "bg:${promptBGColor}";
  fg1 = "fg:#6c6c6c";
  fg2 = "fg:#676768";
  promptStyle = "(${fg1} ${promptBGStyle})";
  separator = "[  ](${fg2} ${promptBGStyle})";
in {
  home.activation = {
    copyStarshipConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run cp --no-preserve=mode -f $XDG_CONFIG_HOME/starship.toml ${me.flake-path}/preferences/home/cli/shells/starship.toml
    '';
  };
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
          "[](fg:${promptBGColor})"
          "$fill"
          "[](fg:${promptBGColor})$nodejs"
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
            git_bg = "${promptBGColor}";
            dir_bg = "${promptBGColor}";
            dir_fg = "#fc874f";
            os_bg = "${promptBGColor}";
            os_fg = "#eeeeee";
            nix_bg = "${promptBGColor}";
            nix_fg = "#ff719c";
            # shell_fg = "#9c5e41";
            shell_fg = "#428c3e";
            shell_bg = "${promptBGColor}";
            shlvl_fg = "#c6ae70";
            node_bg = "${promptBGColor}";
          };
        };

        os = {
          disabled = false;
          format = "$symbol";
          style = "bg:os_bg";

          symbols.NixOS = "[ ]($style fg:#7eb7df)";
          symbols.Windows = "[ ]($style fg:#00a8e8)";
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
          style = "bg:shell_bg";
          fish_indicator = "[🐟]($style fg:#4bb748)";
          bash_indicator = "[]($style fg:#bbbbbb bold)";
          nu_indicator = "[nu]($style fg:#4e9a06)[]($style fg:#f2f2f2)";
          # bash_indicator = "󱆃";
          powershell_indicator = "[󰨊]($style fg:#1b74c1)";
          format = "${separator}$indicator";
        };

        shlvl = {
          disabled = false;
          # format = "${separator}[ $shlvl]($style)";
          format = "${separator}[󰽘 $shlvl]($style)";
          style = "bg:os_bg fg:shlvl_fg";
        };

        nix_shell = {
          disabled = false;
          symbol = "";
          format = "${separator}[$symbol]($style)$state";
          impure_msg = "[ 󰇷](bg:nix_bg fg:nix_fg)";
          style = "bg:nix_bg fg:nix_fg";
        };

        git_branch = {
          symbol = "";
          style = "fg:#008700 bg:#0e1920";
          format = "${separator}[$symbol $branch]($style)";
        };

        git_status = {
          style = "fg:#008700 bg:#0e1920";
          format = "[($staged $modified $stashed)]($style)";
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
          symbol = "";
          format = "${separator}[$symbol ($version)]($style)";
        };
      };
    };
  };
}
