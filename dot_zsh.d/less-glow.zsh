
less() {
    # find the last argument that doesn't start with - (i.e. the file)
    local file
    for arg in "$@"; do
        [[ "$arg" == -* ]] || file="$arg"
    done

    if [[ "$file" == *.md ]] && command -v glow > /dev/null; then
        glow -p "$file"
    else
        command less "$@"
    fi
}
