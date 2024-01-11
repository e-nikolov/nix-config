{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.videoDrivers = ["intel"];
  services.xserver.enable = true;
  services.xserver.layout = "us,bg";
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.xkbOptions = "caps:escape";

  environment.systemPackages = [
    pkgs.xdotool
  ];
}
