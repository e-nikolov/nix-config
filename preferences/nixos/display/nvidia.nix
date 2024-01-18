{
  pkgs,
  lib,
  inputs,
  ...
}: {
  # NVIDIA drivers are unfree.
  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.nvidia.acceptLicense = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
