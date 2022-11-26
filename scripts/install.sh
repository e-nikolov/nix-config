#!/bin/sh

repo="https://github.com/e-nikolov/nixpkgs-config"
location="$HOME/nix-config"

echo 'configuring nix'

echo $location

if [ -d "$location" ] ;
then
    echo $location already exists
else
    git clone $repo $location
fi

cd $location

git pull

# home-manager switch --flake .
home-manager switch --flake . $*
