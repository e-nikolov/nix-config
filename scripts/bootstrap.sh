#!/bin/sh


set -e

# install nix if missing

if [ $(command -v nix) ]
then
    echo nix is present
else
    echo installing nix
    curl -L https://nixos.org/nix/install | sh
    echo installing nix... done

    NIX_LINK="$HOME/.nix-profile"
    p_sh=$NIX_LINK/etc/profile.d/nix.sh
    source ${p_sh}
fi

INSTALL_SCRIPT=install-minimal.sh
export INSTALL_LOCATION="$HOME/nix-config"

# handle the command line flags
while [ $# -gt 0 ]; do
    case $1 in
        --full)
            INSTALL_SCRIPT="install.sh"
            ;;
        --location)
            export INSTALL_LOCATION=$2
            ;;
        *)
            {
                echo "nix flake installer [--full][--location STRING]"

                echo "Choose installation flavor."
                echo ""
                echo " --full:      Installs a more advanced flake setup"
                echo " --location:  Location to install to; Defaults to ~/nix-config"
                echo ""
            } >&2

            exit;;
    esac
    shift
done

nix-shell https://github.com/e-nikolov/nix-config/archive/master.tar.gz --tarball-ttl 0 --command "$INSTALL_SCRIPT $*" 
