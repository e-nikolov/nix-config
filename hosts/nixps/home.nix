{ config, pkgs, id, inputs, ... }:
let
  yakuake_autostart = (pkgs.makeAutostartItem { name = "yakuake"; package = pkgs.yakuake; srcPrefix = "org.kde."; });
  _1password_autostart = (pkgs.makeAutostartItem { name = "1password"; package = pkgs._1password-gui; });

  popcorntime = (pkgs.popcorntime.overrideAttrs (final: old: rec {
    desktopItem = pkgs.makeDesktopItem (with old; {
      name = pname;
      exec = pname;
      icon = pname;
      comment = meta.description;
      genericName = meta.description;
      type = "Application";
      desktopName = "Popcorn-Time";
      categories = [ "Video" "AudioVideo" ];
    });

    installPhase = old.installPhase + ''

      ln -s ${desktopItem}/share/applications/popcorntime.desktop $out/share/applications/popcorntime.desktop
    '';
  }));
in
{
  home.packages = [
    pkgs.xclip
    pkgs.vscode
    pkgs.firefox
    pkgs.yakuake
    pkgs.konsole
    pkgs.ark
    pkgs.krita
    pkgs.vlc

    yakuake_autostart
    _1password_autostart

    popcorntime
  ];

  home.file.".local/share/konsole/termix.profile".source = ../../dotfiles/termix.profile;
  home.file.".local/share/konsole/termix.colorscheme".text = ''
    [Background]
    Color=35,38,39
    RandomHueRange=360
    RandomSaturationRange=100

    [BackgroundFaint]
    Color=49,54,59
    RandomHueRange=360
    RandomSaturationRange=100

    [BackgroundIntense]
    Color=0,0,0
    RandomHueRange=360
    RandomSaturationRange=100

    [Color0]
    Color=35,38,39

    [Color0Faint]
    Color=49,54,59

    [Color0Intense]
    Color=127,140,141

    [Color1]
    Color=237,21,21

    [Color1Faint]
    Color=120,50,40

    [Color1Intense]
    Color=192,57,43

    [Color2]
    Color=17,209,22

    [Color2Faint]
    Color=23,162,98

    [Color2Intense]
    Color=28,220,154

    [Color3]
    Color=246,116,0

    [Color3Faint]
    Color=182,86,25

    [Color3Intense]
    Color=253,188,75

    [Color4]
    Color=29,153,243

    [Color4Faint]
    Color=27,102,143

    [Color4Intense]
    Color=61,174,233

    [Color5]
    Color=155,89,182

    [Color5Faint]
    Color=97,74,115

    [Color5Intense]
    Color=142,68,173

    [Color6]
    Color=26,188,156

    [Color6Faint]
    Color=24,108,96

    [Color6Intense]
    Color=22,160,133

    [Color7]
    Color=252,252,252

    [Color7Faint]
    Color=99,104,109

    [Color7Intense]
    Color=255,255,255

    [Foreground]
    Color=252,252,252
    RandomHueRange=360
    RandomSaturationRange=100

    [ForegroundFaint]
    Color=239,240,241
    RandomHueRange=360
    RandomSaturationRange=100

    [ForegroundIntense]
    Color=255,255,255
    RandomHueRange=360
    RandomSaturationRange=100

    [General]
    Anchor=0.5,0.5
    Blur=true
    ColorRandomization=true
    Description=Breeze
    FillStyle=Tile
    Opacity=0.9
    Wallpaper=${config.home.homeDirectory}/.local/share/konsole/termix-bg.png
    WallpaperOpacity=0.9
  '';
  home.file.".local/share/konsole/termix-bg.png".source = ../../images/termix-bg.png;

  programs.vscode = {
    enable = true;
    userSettings = {
      go.formatTool = "gofumports";
      go.useCodeSnippetsOnFunctionSuggest = true;
      go.useLanguageServer = true;
      go.lintTool = "golangci-lint";
      go.autocompleteUnimportedPackages = true;
      rest-client.previewResponsePanelTakeFocus = false;
      rest-client.timeoutinmilliseconds = 10000;
      bookmarks.keepBookmarksOnLineDelete = true;
      bookmarks.sideBar.expanded = true;
      bookmarks.showNoMoreBookmarksWarning = false;
      bookmarks.label.suggestion = "suggestWhenSelectedOrLineWhenNoSelected";
      nix.enableLanguageServer = true;
      indentRainbow.lightIndicatorStyleLineWidth = 2;
      editor.inlineSuggest.enabled = true;
      editor.bracketPairColorization.enabled = true;
      editor.bracketPairColorization.independentColorPoolPerBracketType = true;
      editor.formatOnSave = true;
      editor.suggestSelection = "first";
      bracket-pair-colorizer-2.highlightActiveScope = true;
      editor.mouseWheelZoom = true;

      terminal.integrated.fontFamily = "'MesloLGS NF'";
      terminal.integrated.tabs.enabled = true;
      workbench.colorTheme = "One Dark Pro Darker";
      workbench.iconTheme = "material-icon-theme";
      workbench.editor.wrapTabs = true;
      workbench.editor.decorations.colors = true;
      local-history.path = "~/.vscode-history";
      local-history.daysLimit = 3;
      files.hotExit = "onExitAndWindowClose";
    };
    keybindings = [
      {
        key = "ctrl+n ctrl+n";
        command = "workbench.action.files.newUntitledFile";
      }
      {
        key = "ctrl+n";
        command = "-workbench.action.files.newUntitledFile";
      }
      {
        key = "ctrl+w";
        command = "-editor.action.smartSelect.grow";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+shift+tab";
        command = "workbench.action.previousEditor";
      }
      {
        key = "ctrl+tab";
        command = "workbench.action.nextEditor";
      }
      {
        key = "ctrl+f";
        command = "workbench.action.terminal.focusFindWidget";
        when = "terminalFocus";
      }
      {
        key = "ctrl+f";
        command = "-workbench.action.terminal.focusFindWidget";
        when = "terminalFocus";
      }
      {
        key = "ctrl+shift+b";
        command = "editor.action.referenceSearch.trigger";
        when = "editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor";
      }
      {
        key = "alt+f7";
        command = "-editor.action.referenceSearch.trigger";
        when = "editorHasReferenceProvider && editorTextFocus && !inReferenceSearchEditor";
      }
      {
        key = "ctrl+f2";
        command = "-editor.action.changeAll";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "enter";
        command = "acceptSelectedSuggestion";
        when = "suggestWidgetVisible && textInputFocus";
      }
      {
        key = "ctrl+shift+c";
        command = "-copyFilePath";
        when = "!editorFocus";
      }
      {
        key = "ctrl+enter";
        command = "rest-client.request";
        when = "editorTextFocus && editorLangId == 'http'";
      }
      {
        key = "ctrl+alt+r";
        command = "-rest-client.request";
        when = "editorTextFocus && editorLangId == 'http'";
      }
      {
        key = "ctrl+e";
        command = "bookmarks.toggle";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+alt+k";
        command = "-bookmarks.toggle";
        when = "editorTextFocus";
      }
      {
        key = "shift+f6";
        command = "-editor.action.changeAll";
        when = "editorTextFocus && !editorHasRenameProvider && !editorReadonly";
      }
      {
        key = "ctrl+alt+up";
        command = "bookmarks.jumpToNext";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+alt+l";
        command = "-bookmarks.jumpToNext";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+alt+down";
        command = "bookmarks.jumpToPrevious";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+alt+j";
        command = "-bookmarks.jumpToPrevious";
        when = "editorTextFocus";
      }
      {
        key = "ctrl+s";
        command = "-workbench.action.files.saveAll";
      }
      {
        key = "ctrl+s";
        command = "workbench.action.files.saveFiles";
      }
    ];
  };


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
    # Some mid-level settings:
    files."kglobalshortcutsrc" = {
      "ksmserver"."Log Out" = "Meta+F4,Meta+F4,Log Out";
      "kwin"."Window Maximize" = "Meta+Up,Meta+Up,Maximize Window";
      "kwin"."Expose" = "Meta+F,,Expose";
      "kwin"."Toggle Overview" = "Meta+F,Meta+F,Toggle Overview";
      "yakuake".toggle-window-state = "Alt+\\\\,F12,Open/Retract Yakuake";
    };
    files."plasmarc" = {
      Theme.name = "breeze-dark";
    };

    files."kwinrc" = {
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
    files."plasma-org.kde.plasma.desktop-appletsrc" = {
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
    files.yakuakerc = {
      "Appearance" = {
        HideSkinBorders = true;
        TerminalHighlightOnManualActivation = true;
      };
      "Audio Preview Settings" = {
        Autoplay = false;
      };
      "Behavior" = {
        FocusFollowsMouse = true;
        OpenAfterStart = true;
        RememberFullscreen = true;
      };
      "Shortcuts" = {
        close-session = "Ctrl+W";
        edit-profile = "Ctrl+Alt+Shift+D";
        new-session-quad = "Alt+]";
        next-session = "Alt+Right";
        next-terminal = "Ctrl+Shift+Down";
        options_configure_keybinding = "Ctrl+Alt+S";
        previous-session = "Alt+Left";
        previous-terminal = "Ctrl+Shift+Up";
        rename-session = "F2";
        new-session = "Ctrl+Shift+T; Ctrl+T";
      };
      "Window" = {
        DynamicTabTitles = true;
        Height = 100;
        KeepAbove = false;
        KeepOpen = false;
        KeepOpenAfterLastSessionCloses = true;
        Width = 100;
      };
    };
    files.powermanagementprofilesrc = {
      "AC.DPMSControl" = {
        idleTime = 3600;
        lockBeforeTurnOff = 0;
      };
      "AC.DimDisplay" = {
        idleTime = 3600000;
      };
      "AC.HandleButtonEvents" = {
        lidAction = 0;
        powerButtonAction = 16;
        powerDownAction = 16;
        triggerLidActionWhenExternalMonitorPresent = false;
      };
      "Battery.DPMSControl" = {
        idleTime = 1500;
        lockBeforeTurnOff = 0;
      };
      "Battery.DimDisplay" = {
        idleTime = 900000;
      };
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
}
