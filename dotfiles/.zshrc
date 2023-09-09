### Environment variables and Configs ###

### Key binds ###

### Aliases ###

### Theme ###

## COMPLETIONS ########################################

### Functions ###

export PATH=$PATH:"$HOME/.cargo/bin"

_nar() {
    store_path=$1
    cache=$2
    quiet=$3

    store_path=$(echo $store_path | sed -n 's/\/nix\/store\/\([a-zA-Z0-9]*\)-.*/\1/p')
    url="$cache$store_path.narinfo"

    out=$(curl -s $url)
    if [ "$quiet" ]; then
        if [ "$out" = 404 ]; then
            out="(-)"
        else
            out="(+)"
        fi
        echo $url $out
    else
        echo $url
        echo $out
    fi

}

nar2() {
    local store_paths=()
    while [ $# -gt 0 ]; do
        opt="$1"
        shift

        case $opt in
        -q | --quiet)
            quiet=1
            ;;
        -c | --cache)
            cache="$opt"
            shift
            ;;
        *)
            store_paths+=("$opt")
            ;;
        esac
    done

    if [ ! -t 0 ]; then
        while read line; do
            store_paths+=($(echo $line | tr " " "\n"))
        done
    fi

    if [ ! "$cache" ]; then
        cache="https://cache.nixos.org/"
    fi

    for store_path in "${store_paths[@]}"; do
        _nar $store_path $cache $quiet
    done
}

alias nar='nix path-info --eval-store auto --store https://cache.nixos.org '
alias narp='nix build --dry-run 2>&1 '
