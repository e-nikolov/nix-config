{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  programs.git = {
    enable = true;
    # difftastic = {
    #   enable = true;
    #   background = "dark";
    #   color = "always";
    #   display = "side-by-side-show-both";
    # };

    delta.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      core = {editor = lib.mkDefault "micro";};
      credential = {helper = lib.mkDefault "cache --timeout=3600";};

      pull = {
        rebase = true;
        ff = lib.mkDefault "only";
      };
    };
  };
  home.packages = [];
  home.shellAliases = {
    gct = "git commit -am 'tmp'";
    gst = lib.mkDefault "git status ";
    gcl = lib.mkDefault "git clone --recurse-submodules ";
    gc = lib.mkDefault "git commit ";
  };
}
