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
    news.display = lib.mkForce "silent";
    news.json = lib.mkForce {};
    news.entries = lib.mkForce [];
  };
}
