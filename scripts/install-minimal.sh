#!/bin/sh

echo 'configuring nix'



if [ -d "$INSTALL_LOCATION" ] ;
then
    echo $INSTALL_LOCATION already exists

    rand_suffix=$(echo $RANDOM | md5sum | head -c 10; echo)
    export INSTALL_LOCATION=${INSTALL_LOCATION}-${rand_suffix}
fi

echo installing to $INSTALL_LOCATION

nix flake new --template github:e-nikolov/nix-config#minimal $INSTALL_LOCATION
cd $INSTALL_LOCATION

sed -i s/<username>/$USER/g flake.nix
sed -i s/<username>/$USER/g home.nix

sed -i s/<hostname>/$HOST/g flake.nix
sed -i s/<hostname>/$HOST/g home.nix

sed -i s/<homedir>/$HOME/g flake.nix
sed -i s/<homedir>/$HOME/g home.nix

echo Run this command to finish the installation:
echo home-manager switch --flake . $*
