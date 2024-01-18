# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  me,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9560
    # inputs.nixos-hardware.nixosModules.dell-xps-15-9560-intel

    ../../presets/base/configuration.nix
    ../../presets/desktop/configuration.nix
  ];

  boot = {
    blacklistedKernelModules = ["snd_pcsp"];
    # blacklistedKernelModules = [ "nouveau" "nvidia" ];
    # kernelParams = [ "acpi_rev_override=1" "nomodeset" ];
    kernelParams = ["acpi_rev_override=1"];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        extraEntries = {
          "kubuntu.conf" = ''
            title Kubuntu
            efi /EFI/ubuntu/shimx64.efi
          '';
        };
      };
      efi = {canTouchEfiVariables = true;};
    };
  };
  networking = {
    hostName = "nixps"; # Define your hostname.
    hostId = "a96153f9";
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
    firewall.allowedTCPPorts = [12345];
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_IE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  hardware.bluetooth.enable = true;
  # services.blueman.enable = true;

  programs.partition-manager.enable = true;

  # boot.zfs.requestEncryptionCredentials = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
