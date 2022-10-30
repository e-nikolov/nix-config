#!/bin/sh
# install nix if missing

if [ $(command -v nix) ]
then
    echo nix is present
else
    echo installing nix
    curl -L https://nixos.org/nix/install | sh
fi

nix-shell ../ --run "echo hello"
