{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver = {
    videoDrivers = ["intel"];
    enable = true;
    xkb.layout = "us,bg";
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      startx.enable = true;
      sddm.enable = true;
    };
    # xkbOptions = "caps:escape";
  };

  environment.systemPackages = [
    pkgs.xdotool
  ];
}
