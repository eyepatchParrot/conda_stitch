#!/usr/bin/env bash
realpath() { ( cd -P $1 ; echo $PWD ) ; }
# export _CE_M=

LINK_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LINK_NAME=$(basename $0)
CONDA_PREFIX=$(realpath "${LINK_DIR}/../../..") # /opt/conda/envs/good-base/share/noactivate-env/bin/../../..
CONDA_DEFAULT_ENV=$(basename "${CONDA_PREFIX}")
CONDA_PROMPT_MODIFIER="(${CONDA_DEFAULT_ENV})"
CONDA_EXE=/opt/conda/bin/conda
CONDA_PYTHON_EXE=/opt/conda/bin/python
_CE_CONDA=
CONDA_SHLVL=1
CONDA_NOACTIVATE_SKIP=1
PATH="${CONDA_PREFIX}/bin:/opt/conda/condabin:$PATH"
export LINK_DIR LINK_NAME CONDA_PREFIX CONDA_DEFAULT_ENV CONDA_PROMPT_MODIFIER CONDA_EXE CONDA_PYTHON_EXE _CE_CONDA CONDA_SHLVL CONDA_NOACTIVATE_SKIP PATH
. "${CONDA_PREFIX}/share/noactivate-env/activate-all.sh"
exec "$CONDA_PREFIX/bin/$LINK_NAME" "$@"
