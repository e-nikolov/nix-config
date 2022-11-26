#!/bin/sh

set -e

repo="https://github.com/e-nikolov/nixpkgs-config"

echo 'configuring nix'

echo $INSTALL_LOCATION

if [ -d "$INSTALL_LOCATION" ] ;
then
    echo $INSTALL_LOCATION already exists
else
    git clone $repo $INSTALL_LOCATION
fi

cd $INSTALL_LOCATION

git pull

home-manager switch --flake . $*
