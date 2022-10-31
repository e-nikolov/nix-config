#!/bin/sh
# install nix if missing

if [ $(command -v nix) ]
then
    echo nix is present
else
    echo installing nix
    curl -L https://nixos.org/nix/install | sh
fi

echo 1: $@
echo 2: $*

exec nix-shell https://github.com/e-nikolov/nixpkgs-config/archive/master.tar.gz --tarball-ttl 0 --command \"install.sh $@\"
#  nix-shell https://github.com/e-nikolov/nixpkgs-config/archive/master.tar.gz --tarball-ttl 0 --command "install.sh ++ $@"
