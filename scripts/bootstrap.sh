#!/bin/sh

{ # Prevent execution if this script was only partially downloaded
    oops() {
        echo "$0:" "$@" >&2
        exit 1
    }
    set -e

    # install nix if missing
    export NIX_CONFIG="extra-experimental-features = flakes nix-command auto-allocate-uids"
    export HOME_CONFIG_PATH="$HOME/nix-config"

    # # handle the command line flags
    while [ $# -gt 0 ]; do
        case $1 in
        --template)
            FLAKE_TEMPLATE=$2

            shift
            ;;
        --help | -h | -\?)
            {
                echo "nix flake installer [--template STRING] path STRING"

                echo "Choose installation flavor."
                echo ""
                echo " --template: [bare|minimal|full|<flake-template-url>]; Defaults to minimal"
                echo " path:  Location to install to; Defaults to ~/nix-config"
                echo ""
            } >&2

            exit
            ;;
        *)
            export HOME_CONFIG_PATH=$1
            ;;
        esac
        shift
    done

    if [ "$FLAKE_TEMPLATE" == "minimal" || "$FLAKE_TEMPLATE" == "" ]; then
        FLAKE_TEMPLATE=github:e-nikolov/nix-config/master?dir=modules/minimal#minimal
    elif [ "$FLAKE_TEMPLATE" == "bare" ]; then
        FLAKE_TEMPLATE=github:e-nikolov/nix-config/master?dir=modules/bare#bare
    elif [ "$FLAKE_TEMPLATE" == "full" ]; then
        FLAKE_TEMPLATE=github:e-nikolov/nix-config/master#full
    fi

    if [ ! $(command -v nix) ]; then
        case "$(uname -s)" in
        Darwin)
            nix_installer_type="multi-user"
            ;;
        Linux)
            if [ -d "/run/systemd/system" ]; then
                nix_installer_type="multi-user"
            else
                nix_installer_type="single-user"
            fi
            ;;
        *) oops "sorry, there is no binary distribution of Nix for your platform" ;;
        esac

        echo installing nix via $nix_installer_type installer
        if [ "$nix_installer_type" == "multi-user" ]; then
            curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            nix profile list ## * Avoids ERROR: Could not find suitable profile directory
        else
            curl -L https://nixos.org/nix/install | sh
            . $HOME/.nix-profile/etc/profile.d/nix.sh
            ## * install a second nix with a lower priority than the one from home-manager

            ## * There are some issues with bootstrapping nix and home-manager on single user installs
            ## * After we are done we want home-manager to manage the nix installation
            ## * But we need nix in order to install home-manager
            ## * The nix installer and home-manager both create nix profiles with priority 5 (1 is highest priority).
            ## * Currently there is no way to lower the priority of a profile,
            ## * which makes it impossible to install home-manager while the original nix installer is present.
            ## * Our solution is to add a second nix installation with a lower priority(9) and then remove the original one
            ## * Later on home-manager will install and manage a third nix with the default priority (5)
            ## * which will not clash with the second nix we installed. Finally, after home-manager is installed, we can remove the second nix
            nix profile install nixpkgs#nix --priority 9
        fi
        echo installing nix... done
    else
        echo nix is present
    fi

    if [ $(command -v home-manager) ]; then
        echo home-manager is present
        exit 0
    fi

    if [ -d "$HOME_CONFIG_PATH" ]; then
        echo $HOME_CONFIG_PATH already exists

        rand_suffix=$(
            echo $RANDOM | md5sum | head -c 10
            echo
        )
        export HOME_CONFIG_PATH=${HOME_CONFIG_PATH}-${rand_suffix}
    fi
    echo installing home-manager and initializing its flake config to $HOME_CONFIG_PATH

    nix flake --refresh new --template $FLAKE_TEMPLATE $HOME_CONFIG_PATH
    nix shell home-manager/master nixpkgs#jq --command sh -c "
        ## * There is no easy way to find the original nix package in the current profile
        ## * We use jq to find the index of the package that has priority 5 and a store path that contains *-nix-[digit]*
        i=\$(nix profile list --json | jq '.elements | map(
            if (.priority == 5 and ( [
                    .storePaths[] | 
                    test(\"^/nix/store/.*-nix-[0-9].*$\")
                ] | any )) 
            then true 
            else false 
            end 
            ) | index(true)'
        )
        
        if [ \"\$i\" ]; then
            nix profile remove \$i
        fi

        home-manager init --switch $HOME_CONFIG_PATH -b backup
    "
    ## TODO remove the second nix

} # End of wrapping
