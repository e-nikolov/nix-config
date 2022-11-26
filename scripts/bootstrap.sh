#!/bin/sh
# install nix if missing

if [ $(command -v nix) ]
then
    echo nix is present
else
    echo installing nix
    curl -L https://nixos.org/nix/install | sh
    source ~/.bashrc
fi

INSTALL_SCRIPT=install.sh
export INSTALL_LOCATION="$HOME/nix-config"

# handle the command line flags
while [ $# -gt 0 ]; do
    case $1 in
        --minimal)
            INSTALL_SCRIPT="install-minimal.sh"
            ;;
        --location)
            export INSTALL_LOCATION=$2
            ;;
        *)
            {
                echo "nix flake installer [--minimal][--location STRING]"

                echo "Choose installation flavor."
                echo ""
                echo " --minimal:   Installs a minimal flake"
                echo " --location:  Location to install to; Defaults to ~/nix-config"
                echo ""
            } >&2

            exit;;
    esac
    shift
done

nix-shell https://github.com/e-nikolov/nixpkgs-config/archive/master.tar.gz --tarball-ttl 0 --command "$INSTALL_SCRIPT $*" 
