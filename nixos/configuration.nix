# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
  # boot.kernelParams = [ "acpi_rev_override=1" "nomodeset" ];
  boot.kernelParams = [ "acpi_rev_override=1" ];
  boot.loader = {
    systemd-boot = {
      enable = true;
      extraEntries = {
        "kubuntu.conf" = ''
          title Kubuntu
          efi /EFI/ubuntu/shimx64.efi
        '';
      };
    };
    efi = {
      canTouchEfiVariables = true;
      # efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    };
    #grub = {
    #   efiSupport = true;
    #   #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    #   device = "nodev";
    #};
  };
  boot.plymouth.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.enikolov = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # firefox
      # thunderbird
    ];
  };
  networking.hostName = "nixps"; # Define your hostname.
  networking.hostId = "a96153f9";
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfree = true;
  hardware.opengl.enable = true;
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  i18n.defaultLocale = "en_IE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Enable the X11 windowing system.
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.enable = true;
  services.xserver.layout = "us,bg";
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.runUsingSystemd = true;
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp,esc:swapcaps";

  services.xserver.libinput = {
    enable = true;
    touchpad.clickMethod = "buttonareas";
    touchpad.naturalScrolling = false;
    touchpad.scrollMethod = "twofinger";
    touchpad.disableWhileTyping = true;
    touchpad.middleEmulation = true;
    touchpad.tapping = true;
    touchpad.tappingDragLock = false;

    touchpad.additionalOptions = ''
      Option "PalmDetection" "on"
      Option "TappingButtonMap" "lmr"
    '';
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.dnsname.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    # plymouth
    firefox # use programs.firefox.enable = true; ?
    micro
    yakuake
    konsole
  ];

  programs.git.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "enikolov" ];
  security.pam.services.kwallet.enableKwallet = true;
  security.polkit.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
  system.stateVersion = "22.11"; # Did you read the comment?
}
