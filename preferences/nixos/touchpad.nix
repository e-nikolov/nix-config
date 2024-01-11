{
  pkgs,
  lib,
  self,
  inputs,
  personal-info,
  ...
}: {
  imports = [
  ];

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
}
