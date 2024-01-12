{ config, pkgs, lib, pkgs-stable, inputs, ... }@args: {
  programs.zellij.enable = true;
  programs.zellij.settings = {
    # copy_on_select = false;
    default_layout = "compact";

    keybinds = {
      unbind = [
        "Alt Left"
        "Alt Right"
        "Ctrl 1"
        "Ctrl 3"
        "Ctrl 5"
        "Ctrl 2"
        "Ctrl h"
        "Alt ["
      ];
      normal = {
        "bind \"Ctrl 1\"" = { MoveFocusOrTab = "Left"; };
        "bind \"Ctrl 3\"" = { MoveFocusOrTab = "Right"; };
        "bind \"Ctrl 5\"" = { MoveFocus = "Down"; };
        "bind \"Ctrl 2\"" = { MoveFocus = "Up"; };
        "bind \"Ctrl e\"" = { SwitchToMode = "Tab"; };
        "bind \"Alt t\"" = { NewTab = ""; };
        "bind \"Ctrl [\"" = { PreviousSwapLayout = ""; };
        "bind \"Ctrl ]\"" = { NextSwapLayout = ""; };
      };
    };
  };
}
