{
  config,
  pkgs,
  me,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) toPretty;
  inherit (lib.generators) toJSON;
  noctis = import ./themes/noctis.nix;
in {
  xdg.configFile."winterm/settings.json" = {
    onChange = ''
      cp --no-preserve=mode -f $XDG_CONFIG_HOME/winterm/settings.json ${me.flake-path}/preferences/home/cli/term/winterm.json
    '';

    source = (pkgs.formats.json {}).generate "settings.json" {
      "$help" = "https://aka.ms/terminal-documentation";
      "$schema" = "https://aka.ms/terminal-profiles-schema-preview";

      schemes = [
        noctis.colors

        {
          background = "#292929";
          black = "#0C0C0C";
          blue = "#0037DA";
          brightBlack = "#767676";
          brightBlue = "#3B78FF";
          brightCyan = "#61D6D6";
          brightGreen = "#16C60C";
          brightPurple = "#B4009E";
          brightRed = "#E74856";
          brightWhite = "#F2F2F2";
          brightYellow = "#F9F1A5";
          cursorColor = "#FFFFFF";
          cyan = "#3A96DD";
          foreground = "#CCCCCC";
          green = "#13A10E";
          name = "Campbell";
          purple = "#881798";
          red = "#C50F1F";
          selectionBackground = "#FFFFFF";
          white = "#CCCCCC";
          yellow = "#C19C00";
        }
        {
          background = "#012456";
          black = "#0C0C0C";
          blue = "#0037DA";
          brightBlack = "#767676";
          brightBlue = "#3B78FF";
          brightCyan = "#61D6D6";
          brightGreen = "#16C60C";
          brightPurple = "#B4009E";
          brightRed = "#E74856";
          brightWhite = "#F2F2F2";
          brightYellow = "#F9F1A5";
          cursorColor = "#FFFFFF";
          cyan = "#3A96DD";
          foreground = "#CCCCCC";
          green = "#13A10E";
          name = "Campbell Powershell";
          purple = "#881798";
          red = "#C50F1F";
          selectionBackground = "#FFFFFF";
          white = "#CCCCCC";
          yellow = "#C19C00";
        }
        {
          background = "#1B2932";
          black = "#FC874F";
          blue = "#55AA51";
          brightBlack = "#425866";
          brightBlue = "#68A4CA";
          brightCyan = "#FC874F";
          brightGreen = "#84C8AB";
          brightPurple = "#FC874F";
          brightRed = "#CA8468";
          brightWhite = "#C5D1D3";
          brightYellow = "#D1AA7B";
          cursorColor = "#C5CDD3";
          cyan = "#FFAA44";
          foreground = "#986811";
          green = "#72C09F";
          name = "Noctis Minimus2";
          purple = "#C28097";
          red = "#C08872";
          selectionBackground = "#496D83";
          white = "#C5CDD3";
          yellow = "#C8A984";
        }
        {
          background = "#283033";
          black = "#000000";
          blue = "#3A9BDB";
          brightBlack = "#555555";
          brightBlue = "#A1D7FF";
          brightCyan = "#55FFFF";
          brightGreen = "#93C863";
          brightPurple = "#FF55FF";
          brightRed = "#FF0004";
          brightWhite = "#FFFFFF";
          brightYellow = "#FEF874";
          cursorColor = "#C0CAD0";
          cyan = "#00BBBB";
          foreground = "#CDCDCD";
          green = "#00BB00";
          name = "Obsidian";
          purple = "#BB00BB";
          red = "#A60003";
          selectionBackground = "#455A64";
          white = "#BBBBBB";
          yellow = "#FECD22";
        }
        {
          background = "#282C34";
          black = "#282C34";
          blue = "#61AFEF";
          brightBlack = "#5A6374";
          brightBlue = "#61AFEF";
          brightCyan = "#56B6C2";
          brightGreen = "#98C379";
          brightPurple = "#C678DD";
          brightRed = "#E06C75";
          brightWhite = "#DCDFE4";
          brightYellow = "#E5C07B";
          cursorColor = "#FFFFFF";
          cyan = "#56B6C2";
          foreground = "#DCDFE4";
          green = "#98C379";
          name = "One Half Dark";
          purple = "#C678DD";
          red = "#E06C75";
          selectionBackground = "#FFFFFF";
          white = "#DCDFE4";
          yellow = "#E5C07B";
        }
        {
          background = "#FAFAFA";
          black = "#383A42";
          blue = "#0184BC";
          brightBlack = "#4F525D";
          brightBlue = "#61AFEF";
          brightCyan = "#56B5C1";
          brightGreen = "#98C379";
          brightPurple = "#C577DD";
          brightRed = "#DF6C75";
          brightWhite = "#FFFFFF";
          brightYellow = "#E4C07A";
          cursorColor = "#4F525D";
          cyan = "#0997B3";
          foreground = "#383A42";
          green = "#50A14F";
          name = "One Half Light";
          purple = "#A626A4";
          red = "#E45649";
          selectionBackground = "#FFFFFF";
          white = "#FAFAFA";
          yellow = "#C18301";
        }
        {
          background = "#002B36";
          black = "#002B36";
          blue = "#268BD2";
          brightBlack = "#2A874D";
          brightBlue = "#839496";
          brightCyan = "#93A1A1";
          brightGreen = "#586E75";
          brightPurple = "#6C71C4";
          brightRed = "#CB4B16";
          brightWhite = "#FDF6E3";
          brightYellow = "#657B83";
          cursorColor = "#FFFFFF";
          cyan = "#2AA198";
          foreground = "#839496";
          green = "#859900";
          name = "Solarized Dark";
          purple = "#D33682";
          red = "#DC322F";
          selectionBackground = "#FFFFFF";
          white = "#EEE8D5";
          yellow = "#B58900";
        }
        {
          background = "#FDF6E3";
          black = "#002B36";
          blue = "#268BD2";
          brightBlack = "#073642";
          brightBlue = "#839496";
          brightCyan = "#93A1A1";
          brightGreen = "#586E75";
          brightPurple = "#6C71C4";
          brightRed = "#CB4B16";
          brightWhite = "#FDF6E3";
          brightYellow = "#657B83";
          cursorColor = "#002B36";
          cyan = "#2AA198";
          foreground = "#657B83";
          green = "#859900";
          name = "Solarized Light";
          purple = "#D33682";
          red = "#DC322F";
          selectionBackground = "#FFFFFF";
          white = "#EEE8D5";
          yellow = "#B58900";
        }
        {
          background = "#000000";
          black = "#000000";
          blue = "#3465A4";
          brightBlack = "#555753";
          brightBlue = "#729FCF";
          brightCyan = "#34E2E2";
          brightGreen = "#8AE234";
          brightPurple = "#AD7FA8";
          brightRed = "#EF2929";
          brightWhite = "#EEEEEC";
          brightYellow = "#FCE94F";
          cursorColor = "#FFFFFF";
          cyan = "#06989A";
          foreground = "#D3D7CF";
          green = "#4E9A06";
          name = "Tango Dark";
          purple = "#75507B";
          red = "#CC0000";
          selectionBackground = "#FFFFFF";
          white = "#D3D7CF";
          yellow = "#C4A000";
        }
        {
          background = "#FFFFFF";
          black = "#000000";
          blue = "#3465A4";
          brightBlack = "#555753";
          brightBlue = "#729FCF";
          brightCyan = "#34E2E2";
          brightGreen = "#8AE234";
          brightPurple = "#AD7FA8";
          brightRed = "#EF2929";
          brightWhite = "#EEEEEC";
          brightYellow = "#FCE94F";
          cursorColor = "#000000";
          cyan = "#06989A";
          foreground = "#555753";
          green = "#4E9A06";
          name = "Tango Light";
          purple = "#75507B";
          red = "#CC0000";
          selectionBackground = "#FFFFFF";
          white = "#D3D7CF";
          yellow = "#C4A000";
        }
        {
          background = "#3A2F29";
          black = "#000000";
          blue = "#BD6D00";
          brightBlack = "#6A4F2A";
          brightBlue = "#FFBE55";
          brightCyan = "#C69752";
          brightGreen = "#F6FF40";
          brightPurple = "#FC874F";
          brightRed = "#FF8C68";
          brightWhite = "#FAFAFF";
          brightYellow = "#FFE36E";
          cursorColor = "#FFFFFF";
          cyan = "#F79500";
          foreground = "#FFCB83";
          green = "#A4A900";
          name = "Test";
          purple = "#FC5E00";
          red = "#C13900";
          selectionBackground = "#C14020";
          white = "#FFC88A";
          yellow = "#CAAF00";
        }
        {
          background = "#300A24";
          black = "#171421";
          blue = "#0037DA";
          brightBlack = "#767676";
          brightBlue = "#08458F";
          brightCyan = "#2C9FB3";
          brightGreen = "#26A269";
          brightPurple = "#A347BA";
          brightRed = "#C01C28";
          brightWhite = "#F2F2F2";
          brightYellow = "#A2734C";
          cursorColor = "#FFFFFF";
          cyan = "#3A96DD";
          foreground = "#FFFFFF";
          green = "#26A269";
          name = "Ubuntu-ColorScheme";
          purple = "#881798";
          red = "#C21A23";
          selectionBackground = "#FFFFFF";
          white = "#CCCCCC";
          yellow = "#A2734C";
        }
        {
          background = "#000000";
          black = "#000000";
          blue = "#000080";
          brightBlack = "#808080";
          brightBlue = "#0000FF";
          brightCyan = "#00FFFF";
          brightGreen = "#00FF00";
          brightPurple = "#FF00FF";
          brightRed = "#FF0000";
          brightWhite = "#FFFFFF";
          brightYellow = "#FFFF00";
          cursorColor = "#FFFFFF";
          cyan = "#008080";
          foreground = "#C0C0C0";
          green = "#008000";
          name = "Vintage";
          purple = "#800080";
          red = "#800000";
          selectionBackground = "#FFFFFF";
          white = "#C0C0C0";
          yellow = "#808000";
        }
      ];
      showTabsInTitlebar = true;
      showTerminalTitleInTitlebar = true;
      snapToGridOnResize = false;
      startOnUserLogin = true;
      tabSwitcherMode = "disabled";
      tabWidthMode = "equal";
      theme = "myNewTheme";
      themes = [
        {
          name = "myNewTheme";
          tab = {
            background = null;
            iconStyle = "default";
            showCloseButton = "always";
            unfocusedBackground = "#00000000";
          };
          tabRow = {
            background = "#00000000";
            unfocusedBackground = "#00000000";
          };
          window = {
            applicationTheme = "dark";
            "experimental.rainbowFrame" = false;
            frame = null;
            unfocusedFrame = null;
            useMica = true;
          };
        }
      ];
      actions = [
        {
          command = {
            action = "sendInput";
            input = "[A";
          };
        }
        {
          command = {
            action = "sendInput";
            input = "[V";
          };
          keys = "ctrl+shift+v";
        }
        {
          command = {
            action = "switchToTab";
            index = 7;
          };
          keys = "alt+8";
        }
        {
          command = {
            action = "sendInput";
            input = "[B";
          };
          keys = "ctrl+shift+b";
        }
        {
          command = {
            action = "sendInput";
            input = "[G";
          };
          keys = "ctrl+shift+g";
        }
        {
          command = {
            action = "switchToTab";
            index = 1;
          };
          keys = "alt+2";
        }
        {
          command = {
            action = "sendInput";
            input = "[F";
          };
        }
        {
          command = {
            action = "sendInput";
            input = "[H";
          };
          keys = "ctrl+shift+h";
        }
        {
          command = {
            action = "switchToTab";
            index = 3;
          };
          keys = "alt+4";
        }
        {
          command = {
            action = "sendInput";
            input = "[D";
          };
        }
        {
          command = {
            action = "sendInput";
            input = "[C";
          };
          keys = "ctrl+shift+c";
        }
        {
          command = {
            action = "sendInput";
            input = "[U";
          };
          keys = "ctrl+shift+u";
        }
        {
          command = {
            action = "sendInput";
            input = "[E";
          };
          keys = "ctrl+shift+e";
        }
        {
          command = {
            action = "sendInput";
            input = "[I";
          };
          keys = "ctrl+shift+i";
        }
        {
          command = {
            action = "sendInput";
            input = "[J";
          };
          keys = "ctrl+shift+j";
        }
        {
          command = {
            action = "sendInput";
            input = "[K";
          };
          keys = "ctrl+shift+k";
        }
        {
          command = {
            action = "sendInput";
            input = "[P";
          };
        }
        {
          command = {
            action = "sendInput";
            input = "[Y";
          };
          keys = "ctrl+shift+y";
        }
        {
          command = {
            action = "sendInput";
            input = "[S";
          };
        }
        {
          command = {
            action = "sendInput";
            input = "[L";
          };
          keys = "ctrl+shift+l";
        }
        {
          command = {
            action = "openSettings";
            target = "settingsUI";
          };
          keys = "ctrl+alt+s";
        }
        {
          command = {
            action = "sendInput";
            input = "[M";
          };
        }
        {
          command = "restoreLastClosed";
          keys = "ctrl+shift+t";
        }
        {
          command = {
            action = "sendInput";
            input = "[N";
          };
          keys = "ctrl+shift+n";
        }
        {
          command = "closePane";
          keys = "ctrl+w";
        }
        {
          command = "toggleSplitOrientation";
          keys = "alt+d";
        }
        {
          command = {action = "closeTab";};
          keys = "ctrl+shift+w";
        }
        {
          command = {
            action = "sendInput";
            input = "[X";
          };
          keys = "ctrl+shift+x";
        }
        {
          command = {
            action = "sendInput";
            input = "[O";
          };
          keys = "ctrl+shift+o";
        }
        {
          command = {
            action = "sendInput";
            input = "[Q";
          };
          keys = "ctrl+shift+q";
        }
        {
          command = {
            action = "sendInput";
            input = "[R";
          };
          keys = "ctrl+shift+r";
        }
        {
          command = {
            action = "newTab";
            index = 7;
          };
          keys = "ctrl+shift+2";
        }
        {
          command = {
            action = "sendInput";
            input = "[T";
          };
        }
        {
          command = {
            action = "sendInput";
            input = "[W";
          };
        }
        {
          command = "find";
          keys = "ctrl+f";
        }
        {
          command = {
            action = "sendInput";
            input = "[Z";
          };
          keys = "ctrl+shift+z";
        }
        {
          command = {
            action = "splitPane";
            split = "auto";
            splitMode = "duplicate";
          };
          keys = "ctrl+shift+d";
        }
        {
          command = {action = "selectOutput";};
          keys = "ctrl+2";
        }
        {
          command = {
            action = "globalSummon";
            desktop = "toCurrent";
            dropdownDuration = 1;
            monitor = "toMouse";
            name = "_quake2";
            toggleVisibility = true;
          };
          keys = "win+`";
        }
        {
          command = {
            action = "globalSummon";
            desktop = "toCurrent";
            dropdownDuration = 1;
            monitor = "toMouse";
            name = "_quake2";
            toggleVisibility = true;
          };
          keys = "alt+`";
        }
        {
          command = {
            action = "moveFocus";
            direction = "left";
          };
          keys = "ctrl+alt+left";
        }
        {
          command = {
            action = "openSettings";
            target = "settingsFile";
          };
          keys = "ctrl+alt+shift+s";
        }
        {
          command = {
            action = "switchToTab";
            index = 6;
          };
          keys = "alt+7";
        }
        {
          command = {
            action = "switchToTab";
            index = 5;
          };
          keys = "alt+6";
        }
        {
          command = {action = "commandPalette";};
          keys = "ctrl+shift+a";
        }
        {
          command = {action = "newTab";};
          keys = "alt+t";
        }
        {
          command = "tabSearch";
          keys = "ctrl+shift+f";
        }
        {
          command = "duplicateTab";
          keys = "ctrl+t";
        }
        {
          command = {
            action = "moveFocus";
            direction = "up";
          };
          keys = "ctrl+alt+up";
        }
        {
          command = {
            action = "switchToTab";
            index = 4;
          };
          keys = "alt+5";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+1";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+2";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+3";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+4";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+5";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+6";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+7";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+8";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+9";
        }
        {
          command = "unbound";
          keys = "ctrl+shift+p";
        }
        {
          command = "unbound";
          keys = "ctrl+shift+comma";
        }
        {
          command = "unbound";
          keys = "ctrl+alt+comma";
        }
        {
          command = "unbound";
          keys = "ctrl+comma";
        }
        {
          command = "unbound";
          keys = "alt+shift+minus";
        }
        {
          command = "unbound";
          keys = "alt+shift+plus";
        }
        {
          command = "unbound";
          keys = "alt+up";
        }
        {
          command = "unbound";
          keys = "alt+right";
        }
        {
          command = "unbound";
          keys = "alt+left";
        }
        {
          command = "unbound";
          keys = "alt+down";
        }
        {
          command = "unbound";
          keys = "ctrl+a";
        }
        {
          command = "unbound";
          keys = "ctrl+shift+8";
        }
        {
          command = "unbound";
          keys = "alt+\\";
        }
        {
          command = {
            action = "copy";
            singleLine = false;
          };
          keys = "ctrl+c";
        }
        {
          command = {
            action = "switchToTab";
            index = 2;
          };
          keys = "alt+3";
        }
        {
          command = {
            action = "openSettings";
            target = "defaultsFile";
          };
          keys = "ctrl+alt+shift+d";
        }
        {
          command = {
            action = "switchToTab";
            index = 0;
          };
          keys = "alt+1";
        }
        {
          command = "paste";
          keys = "ctrl+v";
        }
        {
          command = {
            action = "sendInput";
            input = "[24~b";
          };
          keys = "ctrl+space";
          name = "Trigger shell completions";
        }
        {
          command = {
            action = "switchToTab";
            index = 4294967295;
          };
          keys = "alt+9";
        }
        {
          command = {
            action = "showSuggestions";
            source = "commandHistory";
            useCommandline = true;
          };
          keys = "ctrl+h";
        }
        {
          command = {
            action = "moveFocus";
            direction = "down";
          };
          keys = "ctrl+alt+down";
        }
        {
          command = {
            action = "splitPane";
            split = "auto";
          };
        }
        {
          command = {
            action = "moveFocus";
            direction = "right";
          };
          keys = "ctrl+alt+right";
        }
        {command = {action = "selectCommand";};}
        {
          command = "switchSelectionEndpoint";
          keys = "ctrl+shift+m";
        }
        {
          command = "openTabRenamer";
          keys = "f2";
        }
        {
          command = {
            action = "swapPane";
            direction = "previous";
          };
          keys = "ctrl+shift+s";
        }
      ];
      alwaysOnTop = false;
      alwaysShowNotificationIcon = true;
      alwaysShowTabs = true;
      autoHideWindow = false;
      centerOnLaunch = true;
      confirmCloseAllTabs = false;
      copyFormatting = "all";
      copyOnSelect = false;
      defaultProfile = "{ea60d5b3-ce5e-4e67-93aa-ecdb3702fe97}";
      "experimental.rendering.forceFullRepaint" = true;
      firstWindowPreference = "persistedWindowLayout";
      focusFollowMouse = false;
      initialCols = 320;
      initialPosition = ",";
      initialRows = 140;
      launchMode = "maximizedFocus";
      minimizeToNotificationArea = true;
      newTabMenu = [{type = "remainingProfiles";}];
      newTabPosition = "afterCurrentTab";
      profiles = {
        defaults = {
          adjustIndistinguishableColors = "indexed";
          antialiasingMode = "cleartype";
          bellStyle = ["window" "taskbar"];
          closeOnExit = "never";
          colorScheme = "Noctis Minimus";
          "compatibility.reloadEnvironmentVariables" = false;
          cursorShape =
            if noctis.cursor.shape == "BEAM"
            then "bar"
            else noctis.cursor.shape;
          "experimental.autoMarkPrompts" = true;
          "experimental.rightClickContextMenu" = true;
          "experimental.showMarksOnScrollbar" = true;
          font = {face = noctis.font.family;};
          inherit (noctis) opacity;
          useAcrylic = false;
          useAtlasEngine = true;
        };
        list = [
          {
            adjustIndistinguishableColors = "always";
            bellStyle = "none";
            colorScheme = "One Half Dark";
            font = {face = noctis.font.family;};
            guid = "{574e775e-4f2a-5b96-ac1e-a2962a402336}";
            hidden = false;
            name = "PowerShell Preview";
            source = "Windows.Terminal.PowershellCore";
          }
          {
            colorScheme = "One Half Dark";
            font = {face = noctis.font.family;};
            guid = "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}";
            hidden = false;
            name = "Command Prompt";
          }
          {
            colorScheme = "One Half Dark";
            font = {face = noctis.font.family;};
            guid = "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}";
            hidden = false;
            name = "Windows PowerShell";
          }
          {
            font = {face = noctis.font.family;};
            guid = "{b453ae62-4e3d-5e58-b989-0a998ec441b8}";
            hidden = false;
            name = "Azure Cloud Shell";
            source = "Windows.Terminal.Azure";
          }
          {
            adjustIndistinguishableColors = "indexed";
            backgroundImage = null;
            backgroundImageOpacity = 0.02;
            colorScheme = noctis.colors.name;
            commandline = "C:\\WINDOWS\\system32\\wsl.exe -d nix";
            "experimental.retroTerminalEffect" = false;
            font = {face = noctis.font.family;};
            guid = "{50b8f879-b630-4177-888b-55ac70095a1d}";
            hidden = false;
            icon = "\\\\wsl.localhost\\nix\\home\\enikolov\\nix-config\\images\\nix-snowflake.png";
            intenseTextStyle = "all";
            name = "nix";
            opacity = 75;
            padding = "8";
            startingDirectory = "~";
            unfocusedAppearance = {adjustIndistinguishableColors = "indexed";};
            useAcrylic = true;
          }
          {
            adjustIndistinguishableColors = "always";
            font = {face = noctis.font.family;};
            guid = "{a3a2e83a-884a-5379-baa8-16f193a13b21}";
            hidden = false;
            name = "PowerShell 7 Preview";
            source = "Windows.Terminal.PowershellCore";
          }
          {
            font = {face = noctis.font.family;};
            guid = "{51855cb2-8cce-5362-8f54-464b92b32386}";
            hidden = false;
            name = "Ubuntu";
            source = "CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc";
          }
          {
            commandline = "C:\\WINDOWS\\system32\\wsl.exe -d NixOS";
            guid = "{f60b0ee8-276a-5b9c-b48d-fba9910d6a67}";
            hidden = false;
            name = "NixOS2";
            source = "Windows.Terminal.Wsl";
          }
          {
            adjustIndistinguishableColors = "indexed";
            backgroundImage = null;
            backgroundImageOpacity = 0.02;
            colorScheme = "Noctis Minimus";
            commandline = "C:\\WINDOWS\\system32\\wsl.exe -d NixOS";
            "experimental.retroTerminalEffect" = false;
            font = {face = noctis.font.family;};
            guid = "{ea60d5b3-ce5e-4e67-93aa-ecdb3702fe97}";
            hidden = false;
            icon = "\\\\wsl.localhost\\nix\\home\\enikolov\\nix-config\\images\\nix-snowflake.png";
            intenseTextStyle = "all";
            name = "NixOS";
            opacity = 75;
            padding = "8";
            startingDirectory = "~";
            unfocusedAppearance = {adjustIndistinguishableColors = "indexed";};
            useAcrylic = true;
          }
          {
            guid = "{2595cd9c-8f05-55ff-a1d4-93f3041ca67f}";
            hidden = false;
            name = "PowerShell Preview (msix)";
            source = "Windows.Terminal.PowershellCore";
          }
        ];
      };
      useAcrylicInTabRow = false;
      windowingBehavior = "useAnyExisting";
      wordDelimiters = " /\\()\"'.,:;<>~!@#$%^&*|+=[]{}~?│";
    };
  };
}
