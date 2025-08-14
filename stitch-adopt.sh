#!/usr/bin/bash
set -x
NAME=$(basename $(git remote -v | grep -v eyepatchParrot/conda_stitch | head -1 | grep -E -o '[^/]+'\.git) .git)
BRANCH="stitch-$NAME"
git checkout -b stitch-$NAME
git remote add stitch git@github.com:eyepatchParrot/conda_stitch.git
