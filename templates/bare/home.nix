{
  lib,
  config,
  options,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nix-index-database.hmModules.nix-index];

  nix.package = lib.mkDefault pkgs.nixFlakes;

  nix.settings.experimental-features = ["flakes" "nix-command" "repl-flake" "auto-allocate-uids"];
  nix.settings.keep-derivations = lib.mkDefault true;
  nix.settings.keep-outputs = lib.mkDefault true;
  nix.settings.auto-optimise-store = lib.mkDefault true;
  nix.settings.nix-path = [
    "nixpkgs=${inputs.nixpkgs.outPath}"
  ];
  nix.settings.use-xdg-base-directories = lib.mkDefault true;
  nix.settings.log-lines = lib.mkDefault 20;
  targets.genericLinux.enable = lib.mkDefault true;
  xdg.enable = lib.mkDefault true;

  programs.home-manager.enable = lib.mkDefault true;
  programs.direnv.enable = lib.mkDefault true;
  programs.direnv.nix-direnv.enable = lib.mkDefault true;
  programs.nix-index-database.comma.enable = lib.mkDefault true;

  home.packages =
    [
      ## * Add Packages here

      pkgs.nix
      pkgs.jq
      pkgs.direnv
      pkgs.xclip
      pkgs.wl-clipboard
      pkgs.bash-completion
      pkgs.sops
      pkgs.age
      pkgs.nixos-option
      pkgs.nix-doc
      pkgs.git
      pkgs.tmux
      pkgs.skim
      pkgs.fzy
      pkgs.sd-switch
      (pkgs.stdenv.mkDerivation {
        name = "nix-index";
        buildInputs = [pkgs.nix-index-unwrapped];
        buildCommand = ''
          mkdir -p $out/bin
          cp ${pkgs.nix-index-unwrapped}/bin/nix-index $out/bin/
        '';
      })
      # pkgs.nix-index
      # pkgs.fortune
      # pkgs.hello
      # pkgs.cowsay
    ]
    ++ [];
  systemd.user.startServices = "sd-switch";
  home.sessionVariables = {
    NODE_PATH = lib.mkDefault "$HOME/.npm-packages/lib/node_modules";
    HOME_MANAGER_CONFIG = lib.mkDefault "$HOME/nix-config";
  };

  # FIXME: This is not working for zsh
  home.sessionPath = ["$HOME/.local/bin" "$HOME/.npm-packages/bin"];

  # meta.priority = 4;

  home.shellAliases = {
    nfe = lib.mkDefault "$EDITOR ~/nix-config/ ";
    ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
    nfu = lib.mkDefault "nix flake update ~/nix-config ";
    nh = lib.mkDefault "home-manager --flake ~/nix-config ";
    ns = lib.mkDefault "nix shell ";
    # nd = lib.mkDefault "nix develop ";
    gst = lib.mkDefault "git status ";
    gcl = lib.mkDefault "git clone --recurse-submodules ";
    gc = lib.mkDefault "git commit ";
    sudo = lib.mkDefault ''sudo -E env "PATH=$PATH" '';
  };

  programs.bash = {
    enable = lib.mkDefault true;

    initExtra = lib.mkDefault ''
      ### Functions ###

      if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        xc() {
            wl-copy
        }
      else
        xc() {
            xclip -selection clipboard
        }
      fi

      nhs() {
        home-manager switch --flake ~/nix-config $@ && exec bash
      }

      nrs() {
        sudo nixos-rebuild switch --flake ~/nix-config/ $@ && exec bash
      }

      nd() {
        nix develop "$@"
      }
    '';
  };

  # programs.ssh = {
  #   forwardAgent = true;
  #   enable = true;
  #   extraConfig = ''
  #     AddKeysToAgent yes
  #   '';
  # };

  # programs.git = {
  #   enable = true;
  #   difftastic.enable = true;
  #   extraConfig = {
  #     credential = {
  #       helper = "cache --timeout=3600";
  #     };
  #     url = {
  #       "git@github.com:" = {insteadOf = "https://github.com/";};
  #       "ssh://git@bitbucket.org/" = {insteadOf = "https://bitbucket.org/";};
  #     };
  #     pull = {
  #       ff = "only";
  #     };
  #   };
  # };

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
