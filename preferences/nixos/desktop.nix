{
  pkgs,
  lib,
  self,
  inputs,
  ...
}: {
  boot.plymouth.enable = true;

  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  services.upower.enable = true;

  security = {
    # allow wayland lockers to unlock the screen
    pam.services.swaylock.text = "auth include login";

    # realtime kit for low latency audio
    rtkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["kde"];
      hyprland.default = ["kde" "hyprland"];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-kde
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.videoDrivers = ["intel"];
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.enable = true;
  services.xserver.layout = "us,bg";
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.runUsingSystemd = true;
  # services.xserver.xkbOptions = "caps:escape";
  programs.xwayland.enable = true;

  environment.variables.NIXOS_OZONE_WL = "1";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # NVIDIA drivers are unfree.
  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.nvidia.acceptLicense = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware = {
    # smooth backlight control
    brillo.enable = true;
    opengl = {
      enable = true;
      # extraPackages = with pkgs; [
      #   libva
      #   vaapiVdpau
      #   libvdpau-va-gl
      # ];
      # extraPackages32 = with pkgs.pkgsi686Linux; [
      #   vaapiVdpau
      #   libvdpau-va-gl
      # ];
    };

    # using PipeWire instead
    pulseaudio.enable = lib.mkForce false;
  };
}
