{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [../../presets/base/home.nix ../../presets/wsl/home.nix];
}
