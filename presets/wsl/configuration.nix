{ inputs, lib, pkgs, config, modulesPath, personal-info, ... }: {
  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    nativeSystemd = true;
    wslConf.boot.systemd = true;
    interop.register = true;
    wslConf.network.generateResolvConf = true;
    wslConf.network.generateHosts = false;
    defaultUser = personal-info.username;

    # wslConf.automount.root = "/mnt";
    # interop.preserveArgvZero = false;
    # wslConf.interop.enabled = true;
    # wslConf.interop.appendWindowsPath = true;
  };
  security.sudo.wheelNeedsPassword = true;

  services.gnome.gnome-keyring.enable = true;
}
