{
  inputs,
  lib,
  pkgs,
  config,
  modulesPath,
  me,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    nativeSystemd = true;
    interop.register = true;
    # interop.preserveArgvZero = false;
    # interop.enabled = true;
    # interop.appendWindowsPath = true;
    wslConf = {
      boot.systemd = true;
      network = {
        generateResolvConf = true;
        generateHosts = false;
      };
      # automount.root = "/mnt";
    };
    defaultUser = me.username;
  };
  security.sudo.wheelNeedsPassword = true;

  services.gnome.gnome-keyring.enable = true;
}
