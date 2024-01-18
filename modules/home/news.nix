{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
in {
  # disabledModules = ["misc/news.nix"];
  # options = {
  #   news = mkOption {
  #     type = types.attrs;
  #     default = {};
  #     description = ''
  #       A set of news entries to display on login.
  #     '';
  #   };
  # };
  config = {
    news = {
      display = lib.mkForce "silent";
      json = lib.mkForce {};
      entries = lib.mkForce [];
    };
  };
}
