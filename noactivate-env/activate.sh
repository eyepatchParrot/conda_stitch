CONDA_NOACTIVATE_ACTIVATEDIR="$CONDA_PREFIX/etc/conda/activate.d"

conda_noactivate_env_cat_activate() {
    [ -d "$CONDA_NOACTIVATE_ACTIVATEDIR" ] || return 0
    pushd "${CONDA_NOACTIVATE_ACTIVATEDIR}" > /dev/null
    shopt -s nullglob
    local scripts=(*.sh)
    shopt -u nullglob
    touch "$CONDA_PREFIX/share/noactivate-env/activate-all.sh"
    [ -n "$scripts" ] && cat "$scripts" > "$CONDA_PREFIX/share/noactivate-env/activate-all.sh"
    popd > /dev/null
}

conda_noactivate_env_import() {
[ -z "${CONDA_NOACTIVATE_SKIP}" ] || return 0
[ -d "$CONDA_PREFIX/bin" ] || return 0
local wrapdir="$CONDA_PREFIX/share/noactivate-env/bin"
[ -d $wrapdir ] && rm -r $wrapdir
mkdir -p $wrapdir
pushd $wrapdir > /dev/null
for f in $(find -L "$CONDA_PREFIX/bin" -maxdepth 1 -type f -perm -u=x | xargs -r -n 1 basename); do
    ln -s ../env.sh "$f"
done
popd > /dev/null
}
conda_noactivate_env_import
conda_noactivate_env_cat_activate

unset CONDA_NOACTIVATE_ACTIVATEDIR
unset CONDA_NOACTIVATE_SKIP
