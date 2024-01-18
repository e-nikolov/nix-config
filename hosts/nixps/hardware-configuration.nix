# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "rtsx_pci_sdmmc"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "zroot/nixos";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    "/home/enikolov" = {
      device = "zroot/nixos/home/enikolov";
      fsType = "zfs";
      mountPoint = "/home/enikolov";
    };

    "/home/enikolov/data" = {
      device = "zroot/nixos/data";
      fsType = "zfs";
      mountPoint = "/home/enikolov/data";
    };

    "/mnt/nix-ubuntu" = {
      device = "zroot/data/nix";
      fsType = "zfs";
      mountPoint = "/mnt/nix-ubuntu";
    };

    "/mnt/home/enikolov" = {
      device = "zroot/data/home/enikolov";
      fsType = "zfs";
      mountPoint = "/mnt/home/enikolov";
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/71c4bafc-f364-40f4-bf18-7186b65cd497";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethf56a0d1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
