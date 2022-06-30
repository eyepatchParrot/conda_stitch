set -x
mkdir -p $PREFIX/src
cp -r $RECIPE_DIR/tools $PREFIX/src/
cp $RECIPE_DIR/WORKSPACE $PREFIX/src/
cp $RECIPE_DIR/.bazelrc $PREFIX/src/
