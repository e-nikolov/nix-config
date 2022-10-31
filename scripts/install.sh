#!/bin/sh

echo 123

echo 3: $@
echo 4: $*


repo="https://github.com/e-nikolov/nixpkgs-config"
location="$HOME/.config/nixpkgs-test"

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

echo 5: $@
echo 6: $*

# home-manager switch --flake .
home-manager switch --flake . $@

