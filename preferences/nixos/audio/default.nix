{
  pkgs,
  lib,
  self,
  inputs,
  personal-info,
  ...
}: {
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

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # see https://github.com/fufexan/nix-gaming/#pipewire-low-latency
    lowLatency.enable = true;
  };
  sound.enable = true;

  users.users.${personal-info.username} = {
    isNormalUser = true;
    extraGroups = [
      "audio"
    ];
  };
}
