{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix.package = pkgs.nix;
  nix.settings.experimental-features = ["flakes" "nix-command" "repl-flake" "ca-derivations" "auto-allocate-uids"];
  nix.settings.keep-derivations = true;
  nix.settings.keep-outputs = true;
  nix.settings.auto-optimise-store = true;
  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  home.sessionVariables = {
    NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
    PATH = "$HOME/.local/bin:$HOME/.npm-packages/bin:$PATH";
    HOME_MANAGER_CONFIG = "$HOME/nix-config";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-packages/bin"
  ];

  home.priority = 4;

  home.shellAliases = {
    hm = "home-manager --flake ~/nix-config ";
    hme = "$EDITOR ~/nix-config/ ";
    hmu = "nix flake update ~/nix-config  ";
    hms = "home-manager switch --flake ~/nix-config ";
    xc = "xclip -selection clipboard ";
    gst = "git status ";
  };
  programs.bash.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages =
    [
      ## * Add Packages here

      pkgs.nix
      pkgs.jq
      pkgs.direnv
      pkgs.xclip
      pkgs.bash-completion
      pkgs.sops
      pkgs.age
      pkgs.nixos-option
      pkgs.nix-doc
      pkgs.git

      # pkgs.cachix
      # pkgs.devenv

      # pkgs.comma
      # pkgs.fortune
      # pkgs.hello
      # pkgs.cowsay
    ]
    ++ [];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

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
