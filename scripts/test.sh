#!/usr/bin/env bash

if [[ ! -d ~/nix-config ]]; then
    echo "~/nix-config does not exist, skipping update"
    exit 0
fi

cd ~/nix-config
branch_name="$(git symbolic-ref HEAD 2>/dev/null)"

if [ "$branch_name" != "refs/heads/master" ]; then
    echo "Not on master, skipping update"
    exit 0
fi
if [[ $(git diff --stat) != '' ]]; then
    echo 'Dirty working tree, skipping update'
    exit 0
else
    echo 'clean'
fi

echo "Fetching latest changes"
git fetch

if [[ $(git log HEAD..origin/master --oneline) ]]; then
    echo "Up-to-date"
    exit 0
fi

if [[ $(git log origin/master..HEAD --oneline) ]]; then
    echo "Unpushed commits, skipping update"
    exit 0
fi

echo "Pulling latest changes"
git pull

echo "Upgrading home environment"

home-manager switch --flake ~/nix-config
