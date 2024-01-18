{
  pkgs,
  lib,
  inputs,
  me,
  ...
}: {
  imports = [
  ];

  services.xserver.libinput = {
    enable = true;
    touchpad = {
      clickMethod = "buttonareas";
      naturalScrolling = false;
      scrollMethod = "twofinger";
      disableWhileTyping = true;
      middleEmulation = true;
      tapping = true;
      tappingDragLock = false;

      additionalOptions = ''
        Option "PalmDetection" "on"
        Option "TappingButtonMap" "lmr"
      '';
    };
  };
}
