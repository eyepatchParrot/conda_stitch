#!/bin/sh
LINK_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LINK_NAME=$(basename $0)
export CONDA_PREFIX=$(realpath "${LINK_DIR}/../../..") # /opt/conda/envs/good-base/share/noactivate-env/bin/../../..
export CONDA_DEFAULT_ENV=$(basename "${CONDA_PREFIX}")
export CONDA_PROMPT_MODIFIER="(${CONDA_DEFAULT_ENV})"
export CONDA_EXE=/opt/conda/bin/conda
export CONDA_PYTHON_EXE=/opt/conda/bin/python
# export _CE_M=
export _CE_CONDA=
export CONDA_SHLVL=1
export PATH="${CONDA_PREFIX}/bin:/opt/conda/condabin:$PATH"
exec "$CONDA_PREFIX/bin/$LINK_NAME" "$@"
