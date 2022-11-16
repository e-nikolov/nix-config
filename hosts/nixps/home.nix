{ config, pkgs, id, inputs, ... }:
let
  yakuake_autostart = (pkgs.makeAutostartItem { name = "yakuake"; package = pkgs.yakuake; srcPrefix = "org.kde."; });

  nixpkgsPackages = with pkgs; [
    xclip
    vscode
    firefox
    popcorntime
    yakuake
    yakuake_autostart
    konsole
    ark
  ];
in
{
  home.packages = nixpkgsPackages ++ [ ];

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
