set -ex
DEST=$PREFIX/src/tools/rust
mkdir -p $PREFIX/src
cp -R $RECIPE_DIR/tools $PREFIX/src

pushd rules_rust
tar czvf $DEST/rules_rust.tgz .
popd

pushd rules_rust_tinyjson
tar czvf $DEST/tinyjson.tgz .
popd
