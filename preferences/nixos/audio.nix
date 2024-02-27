{
  pkgs,
  lib,
  inputs,
  me,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  nix = {
    settings = {
      substituters = [
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
  };

  hardware.pulseaudio.enable = mkForce false;

  # realtime kit for low latency audio
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;

    # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
    lowLatency.enable = true;
  };
  sound.enable = true;

  users.users.${me.username} = {
    isNormalUser = true;
    extraGroups = [
      "audio"
    ];
  };
}
