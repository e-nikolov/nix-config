# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs }:
{
  # example = pkgs.callPackage ./example { };
  swhkd = pkgs.callPackage ./swhkd.nix { };
}
