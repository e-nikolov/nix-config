{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  home.packages = [
    pkgs.libsForQt5.kaccounts-integration
    pkgs.rc2nix
    pkgs.mesa-demos
    pkgs.vulkan-tools
    pkgs.clinfo
  ];

  xsession.enable = true;

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
        "yakuake".toggle-window-state = "Alt+\\\\	Meta+`,F12,Open/Retract Yakuake";
      };
      "kxkbrc" = {
        Layout = {
          Options = "caps:backspace";
          ResetOldOptions = true;
          SwitchMode = "WinClass";
        };
      };
      "plasmarc" = {Theme.name = "breeze-dark";};

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
      konsolerc = {"Desktop Entry" = {DefaultProfile = "termix.profile";};};

      yakuakerc = {
        "Appearance" = {
          HideSkinBorders = true;
          TerminalHighlightOnManualActivation = true;
        };
        "Audio Preview Settings" = {Autoplay = false;};
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
        "Desktop Entry" = {DefaultProfile = "termix.profile";};
        "Window" = {
          DynamicTabTitles = true;
          Height = 100;
          KeepAbove = false;
          KeepOpen = false;
          KeepOpenAfterLastSessionCloses = true;
          Width = 100;
        };
      };
      kscreenlockerrc = {Daemon = {Autolock = false;};};
      powermanagementprofilesrc = {
        "AC.DPMSControl" = {
          idleTime = 3600;
          lockBeforeTurnOff = 0;
        };
        "AC.DimDisplay" = {idleTime = 3600000;};
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
        "Battery.DimDisplay" = {idleTime = 900000;};
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
