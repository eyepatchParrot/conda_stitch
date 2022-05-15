[ -d ${CONDA_PREFIX}/bin ] || exit 0
WRAPDIR=$CONDA_PREFIX/share/noactivate-env/bin
[ -d $WRAPDIR ] && rm -r $WRAPDIR
mkdir -p $WRAPDIR
pushd $WRAPDIR
for f in $(find -L $CONDA_PREFIX/bin -maxdepth 1 -type f -executable | xargs -r -n 1 basename); do
    ln -s ../env.sh $f
done
popd
