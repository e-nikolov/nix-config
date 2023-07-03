#!/bin/sh

# for bash 4
# this will be called when a command is entered
# but not found in the user’s path + environment
command_not_found_handle () {

    # TODO: use "command not found" gettext translations

    # taken from http://www.linuxjournal.com/content/bash-command-not-found
    # - do not run when inside Midnight Commander or within a Pipe
    if [ -n "${MC_SID-}" ] || ! [ -t 1 ]; then
        >&2 echo "$1: command not found"
        return 127
    fi

    toplevel=nixpkgs # nixpkgs should always be available even in NixOS
    cmd=$1
    attrs=$(@out@/bin/nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$cmd")
    len=$(echo -n "$attrs" | grep -c "^")

    case $len in
        0)
            >&2 echo "$cmd: command not found"
            ;;
        1)
            # if only 1 package provides this, then we can invoke it
            # without asking the users if they have opted in with one
            # of 2 environment variables

            # they are based on the ones found in
            # command-not-found.sh:

            #   NIX_AUTO_INSTALL : install the missing command into the
            #                      user’s environment
            #   NIX_AUTO_RUN     : run the command transparently inside of
            #                      nix shell

            # these will not return 127 if they worked correctly

            if ! [ -z "${NIX_AUTO_INSTALL-}" ]; then
                >&2 cat <<EOF
The program '$cmd' is currently not installed. It is provided by
the package '$toplevel.$attrs', which I will now install for you.
EOF
                nix profile install $toplevel#$attrs
                if [ "$?" -eq 0 ]; then
                    $@ # TODO: handle pipes correctly if AUTO_RUN/INSTALL is possible
                    return $?
                else
                    >&2 cat <<EOF
Failed to install $toplevel.attrs.
$cmd: command not found
EOF
                fi
            elif ! [ -z "${NIX_AUTO_RUN-}" ]; then
                nix-build --no-out-link -A $attrs "<$toplevel>"
                if [ "$?" -eq 0 ]; then
                    # how nix-shell handles commands is weird
                    # $(echo $@) is need to handle this
                    nix shell $toplevel#$attrs --run "$(echo $@)"
                    return $?
                else
                    >&2 cat <<EOF
Failed to install $toplevel.attrs.
$cmd: command not found
EOF
                fi
            else
                    >&2 cat <<EOF
The program '$cmd' is currently not installed. You can install temporarily
by typing:
  nix shell $toplevel#$attr --command zsh
EOF
            fi
            ;;
        *)
            >&2 cat <<EOF
The program '$cmd' is currently not installed. It is provided by
several packages. You can install it temporarily with:

EOF

            while read attr; do
                >&2 echo "  nix shell $toplevel#$attr --command zsh"
            done <<< "$attrs"
            ;;
    esac

    return 127 # command not found should always exit with 127
}

# for zsh...
# we just pass it to the bash handler above
# apparently they work identically
command_not_found_handler () {
    command_not_found_handle $@
    return $?
}