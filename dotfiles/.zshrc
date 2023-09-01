### Environment variables and Configs ###

### Key binds ###

### Aliases ###

### Theme ###

## COMPLETIONS ########################################

### Functions ###

export PATH=$PATH:"$HOME/.cargo/bin"

function ww() {
    local paths=()
    local lines=()
    while IFS= read -r line; do
        if [[ $line =~ ^/ ]]; then
            paths+=("$line")
        else
            lines+=("$line")
        fi 
    done < <(which "$@");

    if [[ ! ${#paths[@]} -eq 0 ]]; then
        realpath $paths | xargs exa -alh --group-directories-first --color always --icons
    fi
    
    for i in $lines; do
        echo $i
    done
}
