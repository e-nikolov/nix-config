#!/bin/sh

set -e

echo 'configuring nix'

if [ -d "$INSTALL_LOCATION" ] ;
then
    echo $INSTALL_LOCATION already exists
    
    rand_suffix=$(echo $RANDOM | md5sum | head -c 10; echo)
    export INSTALL_LOCATION=${INSTALL_LOCATION}-${rand_suffix}
fi

export HOST=$(hostname)

echo installing to $INSTALL_LOCATION
mkdir -p $INSTALL_LOCATION

nix flake --refresh new --template github:e-nikolov/nix-config/master#minimal $INSTALL_LOCATION
cd $INSTALL_LOCATION

echo Configuring the flake for "$USER"@"$HOST" with home "$HOME"

sed -i s@{{username}}@"$USER"@g flake.nix
sed -i s@{{username}}@"$USER"@g home.nix

sed -i s@{{hostname}}@"$HOST"@g flake.nix
sed -i s@{{hostname}}@"$HOST"@g home.nix

sed -i s@{{homedir}}@"$HOME"@g flake.nix
sed -i s@{{homedir}}@"$HOME"@g home.nix
# curl -s "https://api.github.com/repos/NixOS/nixpkgs/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'


# nix -- run home-manager/master -- init --switch $INSTALL_LOCATION -b backup $*

# nix --extra-experimental-features "nix-command flakes" run home-manager/master -- init --switch ~/nix-config
# nix --extra-experimental-features "nix-command flakes" run home-manager/master -- --extra-experimental-features "nix-command flakes" init --switch ~/nix-config
# /nix/store/r1yfx3cckx14ib06hvlzr32w3j20pp8y-home-manager/bin/home-manager switch --extra-experimental-features "nix-command flakes" --flake $HOME/nix-config

# home-manager --extra-experimental-features "nix-command flakes"
echo
echo
echo Run this command to finish the installation:
echo
echo home-manager switch --flake $INSTALL_LOCATION -b backup $*
