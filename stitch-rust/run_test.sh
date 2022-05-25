set -x
DEST=$PREFIX/src/tools/rust
fgrep 'toolchain_for_x86_64-apple-darwin' $DEST/BUILD
tar tf $DEST/tinyjson.tgz | fgrep ./src/json_value.rs
tar tf $DEST/rules_rust.tgz | fgrep ./rust/defs.bzl
