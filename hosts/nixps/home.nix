{ config, pkgs, id, inputs, lib, ... }:
let
  yakuake_autostart = pkgs.makeAutostartItem {
    name = "yakuake";
    package = pkgs.yakuake;
    srcPrefix = "org.kde.";
  };

  vscode-insiders = ((pkgs.vscode.override { isInsiders = true; }).overrideAttrs
    (oldAttrs: rec {
      meta.priority = 4;
      src = (builtins.fetchTarball {
        url =
          "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        sha256 = "sha256:023ryfx9zj7d7ghh41xixsz3yyngc2y6znkvfsrswcij67jqm8cd";
      });
      version = "latest";

      buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    }));
in {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
    ../../modules/home-manager/keyd-application-mapper
    ../../modules/common/home.nix
  ];
  xdg.mimeApps.enable = true;

  home.packages = [
    pkgs.chromium
    pkgs.slack
    pkgs.carla
    pkgs.jack2
    pkgs.jackmix
    pkgs.qpwgraph
    pkgs.qjackctl
    pkgs.paprefs
    pkgs.pamix
    pkgs.viber
    pkgs.unrar
    pkgs.vscode
    vscode-insiders
    pkgs.firefox
    pkgs.yakuake
    pkgs.konsole
    pkgs.ark
    pkgs.krita
    pkgs.vlc
    pkgs.parted
    pkgs.brave
    pkgs.python3
    pkgs.python310Packages.pygments
    pkgs.libreoffice-qt

    pkgs.xdotool
    pkgs.xorg.xev
    pkgs.xkblayout-state
    pkgs.xkb-switch
    pkgs.sublime4
    pkgs.sublime-merge
    pkgs.libsForQt5.kate
    pkgs.libsForQt5.kio-gdrive
    pkgs.libsForQt5.kaccounts-integration
    pkgs.obsidian
    pkgs.vivaldi
    pkgs.microsoft-edge-beta
    pkgs.microsoft-edge
    pkgs.popcorntime

    pkgs.rc2nix
    pkgs.zotero
    pkgs.sxhkd
    pkgs.swhkd
    pkgs.keyd

    yakuake_autostart
  ];

  services.keyd-application-mapper = {
    enable = true;
    settings = {
      "*" = {
        # ";" = ''command (xdotool type "$(date +%Y%m%d-%H%M%S)")'';
        # "k" = ''macro(hello)'';
        # "l" = ''command(ydotool type 123)'';
        # "p" = ''command(xdotool type 123)'';
        #   "alt.shift" = "command(/home/enikolov/.local/state/nix/profile/bin/xkblayout-state set +1)";
        #   "alt.1" = "command(/home/enikolov/.local/state/nix/profile/bin/xkblayout-state set +1)";
        #   "alt.2" = "command(echo 123)";
        #   "alt.3" = "macro(123)";
      };

      "microsoft-edge-beta" = {
        "control+alt.left" = "C-S-k";
        "control+alt.right" = "C-S-l";
        "control+alt.s" = "C-S-i";
      };
    };
  };

  services.sxhkd = {
    # package = pkgs.swhkd;
    enable = true;
    keybindings = {
      # "alt + Shift_L" = "setxkbmap -query | grep -q 'bg,us' && setxkbmap us,bg || setxkbmap bg,us";
      # "alt + Shift_L" = "xkb-switch | grep -q 'us' && xkb-switch -s bg || xkb-switch -s us";
      "alt + Shift_L" = "xkblayout-state set +1";
      "ctrl + shift + greater" = "zotero.sh";
      "ctrl + alt + BackSpace" = "kwin_x11 --replace";
    };
  };

  xsession.enable = true;
  # home.keyboard.options = [
  #   "caps:backspace"
  # ];
  home.file.".local/share/konsole/default.keytab".source =
    ../../dotfiles/default.keytab;
  home.file.".local/share/konsole/termix.profile".source =
    ../../dotfiles/termix.profile;
  home.file.".local/bin/zotero.sh".source = ../../dotfiles/zotero.sh;
  home.file.".local/share/konsole/termix.colorscheme".text = ''
    [Background]
    Color=27,41,50
    RandomHueRange=360
    RandomSaturationRange=100

    [BackgroundFaint]
    Color=73,109,131
    RandomHueRange=360
    RandomSaturationRange=100

    [BackgroundIntense]
    Color=73,109,131
    RandomHueRange=360
    RandomSaturationRange=100

    [Color0]
    Color=252,135,79

    [Color0Faint]
    Color=232,115,59

    [Color0Intense]
    Color=66,88,102

    [Color1]
    Color=221,41,29

    [Color1Faint]
    Color=59,95,203

    [Color1Intense]
    Color=202,132,104

    [Color2]
    Color=68,204,50

    [Color2Faint]
    Color=55,89,191

    [Color2Intense]
    Color=132,200,171

    [Color3]
    Color=200,169,132

    [Color3Faint]
    Color=0,171,171

    [Color3Intense]
    Color=209,170,123

    [Color4]
    Color=85,170,81

    [Color4Faint]
    Color=3,94,139

    [Color4Intense]
    Color=104,164,202

    [Color5]
    Color=187,38,39

    [Color5Faint]
    Color=221,61,125

    [Color5Intense]
    Color=252,135,79

    [Color6]
    Color=255,170,68

    [Color6Faint]
    Color=0,163,200

    [Color6Intense]
    Color=252,135,79

    [Color7]
    Color=197,205,211

    [Color7Faint]
    Color=255,179,128

    [Color7Intense]
    Color=197,209,211

    [Foreground]
    Color=152,104,17

    [ForegroundFaint]
    Color=132,84,0

    [ForegroundIntense]
    Color=172,124,37


    [General]
    Anchor=0.5,0.5
    Blur=true
    ColorRandomization=true
    Description=Noctis Minimus
    FillStyle=Tile
    Opacity=0.9
    WallpaperFlipType=NoFlip

    Wallpaper=${config.home.homeDirectory}/.local/share/konsole/termix-bg.png
    WallpaperOpacity=0.9
  '';
  home.file.".local/share/konsole/termix-bg.png".source =
    ../../images/termix-bg.png;
  home.file.".npmrc".text = ''
    prefix = ${config.home.homeDirectory}/.npm-packages
  '';

  programs.vscode = {
    enable = true;
    # enableUpdateCheck = false;
    package = vscode-insiders;

    extensions = with pkgs.vscode-extensions; [
      hashicorp.terraform
      _2gua.rainbow-brackets
      oderwat.indent-rainbow
      alefragnani.bookmarks
      bbenoist.nix
      golang.go
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      # p1c2u.docker-compose
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "k--kato";
          name = "intellij-idea-keybindings";
          version = "1.5.4";
          sha256 = "sha256-3RNwOQtq/4R13LB6MPYVI4liAT5yXcmCKlb8TBRP5fg=";
        };
        meta = with lib; {
          changelog =
            "https://github.com/kasecato/vscode-intellij-idea-keybindings/blob/master/CHANGELOG.md";
          description = "Port of IntelliJ IDEA key bindings for VS Code.";
          downloadPage =
            "https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings";
          homepage =
            "https://github.com/kasecato/vscode-intellij-idea-keybindings#readme";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
        };
      })
    ];

    #   userSettings = {
    #     go.formatTool = "gofumports";
    #     go.useCodeSnippetsOnFunctionSuggest = true;
    #     go.useLanguageServer = true;
    #     go.lintTool = "golangci-lint";
    #     go.autocompleteUnimportedPackages = true;
    #     rest-client.previewResponsePanelTakeFocus = false;
    #     rest-client.timeoutinmilliseconds = 10000;
    #     bookmarks.keepBookmarksOnLineDelete = true;
    #     bookmarks.sideBar.expanded = true;
    #     bookmarks.showNoMoreBookmarksWarning = false;
    #     bookmarks.label.suggestion = "suggestWhenSelectedOrLineWhenNoSelected";
    #     nix.enableLanguageServer = true;
    #     indentRainbow.lightIndicatorStyleLineWidth = 2;
    #     editor.inlineSuggest.enabled = true;
    #     editor.bracketPairColorization.enabled = true;
    #     editor.bracketPairColorization.independentColorPoolPerBracketType = true;
    #     editor.formatOnSave = true;
    #     editor.suggestSelection = "first";
    #     bracket-pair-colorizer-2.highlightActiveScope = true;
    #     editor.mouseWheelZoom = true;

    #     # terminal.integrated.fontFamily = "'MesloLGS NF'";
    #     terminal.integrated.fontFamily = "'Fira Code'";
    #     terminal.integrated.tabs.enabled = true;
    #     workbench.colorTheme = "One Dark Pro Darker";
    #     workbench.iconTheme = "material-icon-theme";
    #     "livePreview.httpHeaders" = {
    #       Cross-Origin-Opener-Policy = "same-origin";
    #       Cross-Origin-Embedder-Policy = "require-corp";
    #     };
    #     workbench.editor.wrapTabs = true;
    #     workbench.editor.decorations.colors = true;
    #     local-history.path = "~/.vscode-history";
    #     local-history.daysLimit = 3;
    #     files.hotExit = "onExitAndWindowClose";
    #     latex-workshop.view.pdf.external.viewer.args = [
    #       "-shell-escape"
    #       "%PDF%"
    #     ];
    #     latex-workshop.latex.outDir = "%DIR%/build";
    #     # latex-workshop.latex.tools = [{
    #     #   "name" = "pdflatex";
    #     #   "command" = "pdflatex";
    #     #   "args" = [
    #     #     "-shell-escape"
    #     #     "-synctex=1"
    #     #     "-interaction=nonstopmode"
    #     #     "-file-line-error"
    #     #     "%DOC%"
    #     #   ];
    #     #   "env" = { };
    #     # }];
    #     latex-workshop.latex.magic.args = [
    #       "-shell-escape"
    #       "-synctex=1"
    #       "-interaction=nonstopmode"
    #       "-file-line-error"
    #       "%DOC%"
    #     ];
    #   };
    #   keybindings = [
    #     {
    #       key = "ctrl+n ctrl+n";
    #       command = "workbench.action.files.newUntitledFile";
    #     }
    #     {
    #       key = "ctrl+n";
    #       command = "-workbench.action.files.newUntitledFile";
    #     }
    #     {
    #       key = "ctrl+w";
    #       command = "-editor.action.smartSelect.grow";
    #       when = "editorTextFocus";
    #     }
    #     {
    #       key = "ctrl+shift+tab";
    #       command = "workbench.action.previousEditor";
    #     }
    #     {
    #       key = "ctrl+tab";
    #       command = "workbench.action.nextEditor";
    #     }
    #     {
    #       key = "ctrl+f";
    #       command = "workbench.action.terminal.focusFindWidget";
    #       when = "terminalFocus";
    #     }
    #     {
    #       key = "ctrl+f";
    #       command = "-workbench.action.terminal.focusFindWidget";
    #       when = "terminalFocus";
    #     }
    #     {
    #       key = "ctrl+shift+b";
    #       command = "editor.action.referenceSearch.trigger";
    #       when = "editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor";
    #     }
    #     {
    #       key = "alt+f7";
    #       command = "-editor.action.referenceSearch.trigger";
    #       when = "editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor";
    #     }
    #     {
    #       key = "ctrl+f2";
    #       command = "-editor.action.changeAll";
    #       when = "editorTextFocus && !editorReadonly";
    #     }
    #     {
    #       key = "enter";
    #       command = "acceptSelectedSuggestion";
    #       when = "suggestWidgetVisible && textInputFocus";
    #     }
    #     {
    #       key = "ctrl+shift+c";
    #       command = "-copyFilePath";
    #       when = "!editorFocus";
    #     }
    #     {
    #       key = "ctrl+enter";
    #       command = "rest-client.request";
    #       when = "editorTextFocus && editorLangId == 'http'";
    #     }
    #     {
    #       key = "ctrl+alt+r";
    #       command = "-rest-client.request";
    #       when = "editorTextFocus && editorLangId == 'http'";
    #     }
    #     {
    #       key = "ctrl+e";
    #       command = "bookmarks.toggle";
    #       when = "editorTextFocus";
    #     }
    #     {
    #       key = "ctrl+alt+k";
    #       command = "-bookmarks.toggle";
    #       when = "editorTextFocus";
    #     }
    #     {
    #       key = "shift+f6";
    #       command = "-editor.action.changeAll";
    #       when = "editorTextFocus && !editorHasRenameProvider && !editorReadonly";
    #     }
    #     {
    #       key = "ctrl+alt+up";
    #       command = "bookmarks.jumpToNext";
    #       when = "editorTextFocus";
    #     }
    #     {
    #       key = "ctrl+alt+l";
    #       command = "-bookmarks.jumpToNext";
    #       when = "editorTextFocus";
    #     }
    #     {
    #       key = "ctrl+alt+down";
    #       command = "bookmarks.jumpToPrevious";
    #       when = "editorTextFocus";
    #     }
    #     {
    #       key = "ctrl+alt+j";
    #       command = "-bookmarks.jumpToPrevious";
    #       when = "editorTextFocus";
    #     }
    #     {
    #       key = "ctrl+s";
    #       command = "-workbench.action.files.saveAll";
    #     }
    #     {
    #       key = "ctrl+s";
    #       command = "workbench.action.files.saveFiles";
    #     }
    #     {
    #       key = "ctrl+b";
    #       command = "editor.action.openLink";
    #     }
    #   ];  
  };
  programs.kitty.enable = true;
  programs.alacritty.enable = true;
  services.polybar.enable = true;
  services.polybar.script = ''
    polybar bar &
  '';
  services.polybar.extraConfig = ''
    [bar/mybar]
    modules-right = date

    [module/date]
    type = internal/date
    date = %Y-%m-%d%

  '';
  programs.feh.enable = true;

  programs.plasma = {
    enable = true;

    # shortcuts = {
    # ksmserver = {
    #   "Log Out" = "Log Out,Meta+F4";
    # };

    # kwin = {
    #   "Expose" = "Meta+,";
    #   "Toggle Overview" = "Meta+F";
    # };
    # };
    hotkeys.commands = {
      "Launch Konsole" = {
        key = "Meta+R";
        command = "konsole";
      };
      "Launch Browser" = {
        key = "Meta+W";
        command = "firefox";
      };
    };

    configFile = {
      "kglobalshortcutsrc" = {
        "ksmserver"."Log Out" = "Meta+F4,Meta+F4,Log Out";
        "kwin"."Window Maximize" = "Meta+Up,Meta+Up,Maximize Window";
        "kwin"."Expose" = "Meta+F,,Expose";
        "kwin"."Toggle Overview" = "Meta+F,Meta+F,Toggle Overview";
        "yakuake".toggle-window-state =
          "Alt+\\\\	Meta+`,F12,Open/Retract Yakuake";
      };
      "kxkbrc" = {
        Layout = {
          Options = "caps:backspace";
          ResetOldOptions = true;
          SwitchMode = "WinClass";
        };
      };
      "plasmarc" = { Theme.name = "breeze-dark"; };

      "kwinrc" = {
        TabBox = {
          ActivitiesMode = "1";
          ApplicationsMode = "0";
          BorderActivate = "9";
          BorderAlternativeActivate = "9";
          DesktopMode = "1";
          HighlightWindows = "true";
          LayoutName = "thumbnail_grid";
          MinimizedMode = "0";
          MultiScreenMode = "0";
          ShowDesktopMode = "0";
          ShowTabBox = "true";
          SwitchingMode = "0";
        };
        TabBoxAlternative = {
          ActivitiesMode = "1";
          ApplicationsMode = "0";
          DesktopMode = "1";
          HighlightWindows = "true";
          LayoutName = "thumbnails";
          MinimizedMode = "0";
          MultiScreenMode = "0";
          ShowDesktopMode = "0";
          ShowTabBox = "true";
          SwitchingMode = "0";
        };
      };
      "plasma-org.kde.plasma.desktop-appletsrc" = {
        "Containments.23.Applets.45" = {
          immutability = "1";
          plugin = "org.kde.plasma.taskmanager";
        };
        "Containments.23.Applets.45.Configuration.General" = {
          middleClickAction = "ToggleGrouping";
          showOnlyCurrentDesktop = true;
          sortingStrategy = "1";
        };
      };
      konsolerc = { "Desktop Entry" = { DefaultProfile = "termix.profile"; }; };

      yakuakerc = {
        "Appearance" = {
          HideSkinBorders = true;
          TerminalHighlightOnManualActivation = true;
        };
        "Audio Preview Settings" = { Autoplay = false; };
        "Behavior" = {
          FocusFollowsMouse = true;
          OpenAfterStart = true;
          RememberFullscreen = true;
        };
        "Shortcuts" = {
          close-active-terminal = "Ctrl+W";
          edit-profile = "Ctrl+Alt+Shift+D";
          new-session-quad = "Alt+]";
          # next-session = "Alt+Right; Ctrl+Tab";
          next-session = "Ctrl+Tab; Alt+End; Alt+Right";
          previous-session = "Ctrl+Shift+Tab; Alt+Home; Alt+Left";
          next-terminal = "Alt+D";
          options_configure_keybinding = "Ctrl+Alt+S";
          # previous-session = "Alt+Left; Ctrl+Shift+Tab";
          previous-terminal = "Alt+S";
          rename-session = "F2";
          new-session = "Ctrl+Shift+T; Ctrl+T";
          split-left-right = "Ctrl+Shift+S";
          split-top-bottom = "Ctrl+Shift+D";
          edit_paste = "Ctrl+Shift+V; Ctrl+V";
          edit_copy = "Ctrl+Shift+C; Ctrl+C";
        };
        "Desktop Entry" = { DefaultProfile = "termix.profile"; };
        "Window" = {
          DynamicTabTitles = true;
          Height = 100;
          KeepAbove = false;
          KeepOpen = false;
          KeepOpenAfterLastSessionCloses = true;
          Width = 100;
        };
      };
      kscreenlockerrc = { Daemon = { Autolock = false; }; };
      powermanagementprofilesrc = {
        "AC.DPMSControl" = {
          idleTime = 3600;
          lockBeforeTurnOff = 0;
        };
        "AC.DimDisplay" = { idleTime = 3600000; };
        "AC.HandleButtonEvents" = {
          lidAction = 32;
          powerButtonAction = 16;
          powerDownAction = 16;
          triggerLidActionWhenExternalMonitorPresent = false;
        };
        "Battery.DPMSControl" = {
          idleTime = 1500;
          lockBeforeTurnOff = 0;
        };
        "Battery.DimDisplay" = { idleTime = 900000; };
        "Battery.HandleButtonEvents" = {
          lidAction = 1;
          powerButtonAction = 16;
          powerDownAction = 16;
          triggerLidActionWhenExternalMonitorPresent = false;
        };
        "Battery.SuspendSession" = {
          idleTime = 1800000;
          suspendThenHibernate = false;
          suspendType = 1;
        };
      };
    };
  };
}
