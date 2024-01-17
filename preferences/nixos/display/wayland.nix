{ pkgs, lib, self, inputs, personal-info, ... }: {
  environment.variables.NIXOS_OZONE_WL = "1";
  programs.xwayland.enable = true;
  security = {
    # allow wayland lockers to unlock the screen
    pam.services.swaylock.text = "auth include login";
  };
  environment.systemPackages = [
    pkgs.waybar
    pkgs.dunst
    pkgs.kmod
    # pkgs.mako
    pkgs.ydotool
  ];
}
