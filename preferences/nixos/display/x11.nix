{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver = {
    videoDrivers = ["intel"];
    enable = true;
    layout = "us,bg";
    desktopManager = {
      xterm.enable = false;
      startx.enable = true;
      sddm.enable = true;
    };
    # xkbOptions = "caps:escape";
  };

  environment.systemPackages = [
    pkgs.xdotool
  ];
}
