# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{pkgs, ...}: {
  # List your module files here
  # my-module = import ./my-module.nix;
  services.swhkd = pkgs.callPackage ./swhkd.nix {};
  services.keyd-application-mapper = pkgs.callPackage ./keyd-application-mapper.nix {};
  programs.carapace = pkgs.callPackage ./carapace.nix {};
}
