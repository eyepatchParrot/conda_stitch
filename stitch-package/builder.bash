#!/usr/bin/env bash
set -x
export MAMBA_EXE="$(which micromamba)"
export MAMBA_ROOT_PREFIX="/home/pv/micromamba";
eval "$(micromamba shell hook --shell=bash)"
micromamba activate stitch
export CONDA_BLD_PATH=$CONDA_PREFIX/conda-bld
echo $CONDA_PREFIX
echo $CONDA_BLD_PATH
pwd
boa build ${1:-.}
