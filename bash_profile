
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

if [ -e /home/enikolov/.nix-profile/etc/profile.d/nix.sh ]; then . /home/enikolov/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
