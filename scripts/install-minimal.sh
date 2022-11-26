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

nix flake --refresh new --template github:e-nikolov/nixpkgs-config/master#minimal $INSTALL_LOCATION
cd $INSTALL_LOCATION

echo Configuring the flake for "$USER"@"$HOST" with home "$HOME"

sed -i s@{{username}}@"$USER"@g flake.nix
sed -i s@{{username}}@"$USER"@g home.nix

sed -i s@{{hostname}}@"$HOST"@g flake.nix
sed -i s@{{hostname}}@"$HOST"@g home.nix

sed -i s@{{homedir}}@"$HOME"@g flake.nix
sed -i s@{{homedir}}@"$HOME"@g home.nix

echo 
echo 
echo Run this command to finish the installation:
echo home-manager switch --flake $INSTALL_LOCATION -b backup $*
