{
  config,
  lib,
  pkgs,
  ...
}: {
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };
  services.xserver = {
    displayManager.defaultSession = "plasma";
    desktopManager.plasma5.enable = true;
    desktopManager.plasma5.runUsingSystemd = true;
  };
}
