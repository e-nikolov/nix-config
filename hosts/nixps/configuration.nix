# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config
, pkgs
, inputs
, values
, ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ../../modules/nixos/keyd
    ../../modules/common/configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9560-intel
    ./hardware-configuration.nix
  ];

  # boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
  boot.blacklistedKernelModules = [ "snd_pcsp" ];
  # boot.kernelParams = [ "acpi_rev_override=1" "nomodeset" ];
  boot.kernelParams = [ "acpi_rev_override=1" ];
  boot.binfmt.emulatedSystems = [ "armv7l-linux" "aarch64-linux" ];
  boot.loader = {
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
    efi = {
      canTouchEfiVariables = true;
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  services.keyd2.enable = true;
  services.keyd2.keyboards = {
    default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";
          # o = "macro(321)";
          # n = "command(ydotool type 321)";
        };

        control = { };
        alt = { };
        "control+alt" = { };

        # alt = {
        #   "4" = "command(/home/enikolov/.local/state/nix/profile/bin/xkblayout-state set +1)";
        #   "5" = "macro(321)";
        # };

        # "microsoft-edge-beta" = {
        #   "ctrl.alt.left" = "C-S-k";
        #   "ctrl.alt.right" = "C-S-l";
        # };
      };
    };
    # externalKeyboard = {
    #   ids = [ "1ea7:0907" ];
    #   settings = {
    #     main = {
    #       esc = capslock;
    #     };
    #   };
    # };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${values.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "podman"
      "audio"
      "keyd"
    ];
    packages = with pkgs; [
    ];
  };

  # users.groups.keyd = { gid = 33201; };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "nixps"; # Define your hostname.
  networking.hostId = "a96153f9";
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

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
  # services.xserver.xkbOptions = "caps:escape";


  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.partition-manager.enable = true;

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

  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  programs.dconf.enable = true;

  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  # virtualisation.podman.defaultNetwork.dnsname.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    firefox # use programs.firefox.enable = true; ?
    micro
    yakuake
    konsole
    keyd
    plymouth

    pciutils
    waybar

    dunst
    kmod
    mako
    ydotool
    xdotool

    miraclecast
    gnome-network-displays
    libsForQt5.kcalc
  ];

  services.openssh.enable = true;
  programs.git.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ values.username ];
  # programs._1password-gui.package = (pkgs._1password-gui-beta.overrideAttrs
  #   (oldAttrs: {
  #     postInstall = ''
  #       ln -s $out/share/1password/op-ssh-sign $out/bin/op-ssh-sign
  #     '';
  #   }));

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  # boot.zfs.requestEncryptionCredentials = false;
  security.pam.services.kwallet.enableKwallet = true;
  security.polkit.enable = true;

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  networking.firewall.allowedTCPPorts = [ 12345 ];

  # nix.settings.trusted-users = [ "root" "enikolov" ];

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
