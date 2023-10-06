{ config, pkgs, lib, pkgs-stable, inputs, ... }@args: {
  imports = [ ../bare/home.nix ../home-manager/zsh ../home-manager/bash ];
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.nix
    pkgs.micro
    pkgs.htop
    pkgs.nixfmt
    pkgs.curl
    pkgs.git
    # pkgs-stable.ripgrep-all
    # pkgs.ripgrep-all
    pkgs.websocat
    # pkgs.file
    pkgs.tldr
    pkgs.rsync
    pkgs.rnix-lsp
    pkgs.gnupg
    pkgs.gnumake
    pkgs.bc
    pkgs.lsof
    pkgs.meslo-lgs-nf
    pkgs.fira-code
    pkgs.neofetch
    pkgs.sops
    pkgs.age
    pkgs.xxh
    pkgs.nixos-option
    pkgs.nix-doc
    pkgs.xdg-utils

    # pkgs.fortune
    # pkgs.hello
    # pkgs.cowsay
  ] ++ [ ];
  targets.genericLinux.enable = true;
  xdg.enable = true;

  programs.htop.enable = true;
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

  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      background = "dark";
      color = "always";
      display = "side-by-side-show-both";
    };

    extraConfig = {
      core = { editor = lib.mkDefault "micro"; };
      credential = { helper = lib.mkDefault "cache --timeout=3600"; };

      pull = { ff = lib.mkDefault "only"; };
    };
  };

  programs.gitui.enable = true;
  programs.pls.enable = true;
  # programs.carapace.enable = true;
  programs.eza = { enable = true; };

  programs.ssh = {
    forwardAgent = lib.mkDefault true;
    enable = lib.mkDefault true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  fonts.fontconfig.enable = true;

  services.ssh-agent.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
