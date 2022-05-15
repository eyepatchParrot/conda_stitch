set -x
[ -f ./rc/fzf.kak ] || exit 1
DEST=$PREFIX/share/kak/rc/fzf.kak
mkdir -p $DEST
cp -r ./rc $DEST
test -f $DEST/rc/fzf.kak
