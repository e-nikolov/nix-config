{
  pkgs,
  lib,
  self,
  inputs,
  ...
}: {
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
