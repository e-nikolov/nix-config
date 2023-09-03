curl -L https://nixos.org/nix/install | sh
echo test
. ~/.nix-profile/etc/profile.d/nix.sh
# install nix with a lower priority than the flake and remove the original nix so they don't clash
nix profile install nixpkgs#nix --priority 9
nix profile remove nix
