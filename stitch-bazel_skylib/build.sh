set -ex
[ -f ./rules/common_settings.bzl ] || exit 1
DEST=$PREFIX/src/tools/bazel
mkdir -p $DEST
tar czf $DEST/bazel_skylib.tgz .
