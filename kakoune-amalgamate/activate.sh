kakoune_amalgamate() {
    [ -d $CONDA_PREFIX/share/kak ] || return 0
    SHARE="${CONDA_PREFIX}/share/kakoune-amalgamate"
    mkdir -p $SHARE
    find -L "$CONDA_PREFIX/share/kak/autoload" -type f -name '*\.kak' -exec cat {} + > "$SHARE/all.kak"
}
kakoune_amalgamate
unset kakoune_amalgamate
