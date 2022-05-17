set -x
test -f $PREFIX/share/noactivate-env/env.sh
find -L $PREFIX/bin -maxdepth 1 -type f -perm -u=x
find -L $PREFIX/bin -maxdepth 1 -type f -perm -u=x | xargs -r -n 1 basename
