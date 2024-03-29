{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  home.packages = [pkgs.most];
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
      theme = "TwoDark";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batpipe
      batman
      batgrep
      batwatch
    ];
  };

  home.shellAliases = {cat = "bat ";};
}
