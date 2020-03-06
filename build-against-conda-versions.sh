#!/usr/bin/env bash

# Only conda versions in which 'source /dev/start /opt/conda' works
# can be used here.
declare -a CONDA_VERSIONS=()
CONDA_VERSIONS+=(us/4.8.1)
# CONDA_VERSIONS+=(us/4.8.2)
CONDA_VERSIONS+=(ma/master)

declare -a CONDA_BUILD_VERSIONS=()
# CONDA_BUILD_VERSIONS+=(us/3.18.11)
CONDA_BUILD_VERSIONS+=(us/master)

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -a ARGS=()
ARGS+=(--debug)

conda activate

ROOT=/opt/builds-py.c-cb

# rm -rf $ROOT
mkdir $ROOT
pushd $ROOT

  for CONDA_VERSION in "${CONDA_VERSIONS[@]}"; do
    C_DN=${CONDA_VERSION//\//\_}
    C_TAG=${CONDA_VERSION/#*\/}
    C_TAG=${C_TAG##\/}
    echo "C_DN=${C_DN}"
    echo "C_TAG=${C_TAG}"
    git clone https://github.com/mingwandroid/conda.git -o ma conda.${C_DN}
    pushd conda.${C_DN}
      git remote add us https://github.com/conda/conda.git
      git fetch us
      git checkout ${C_TAG}
      rm -f conda.egg-info
      source dev/start /opt/conda
    popd
    for CONDA_BUILD_VERSION in "${CONDA_BUILD_VERSIONS[@]}"; do
      CB_DN=${CONDA_BUILD_VERSION//\//\_}
      CB_TAG=${CONDA_BUILD_VERSION/#*\/}
      echo "DN=${DN}"
      git clone https://github.com/mingwandroid/conda-build.git -o ma conda-build.${CB_DN}
      pushd conda-build.${CB_DN}
        git remote add us https://github.com/conda/conda-build.git
        git fetch us
        git checkout ${CB_TAG}
        python setup.py develop
      popd
      conda-build ${ABSOLUTE_PATH}/recipe -m /opt/Shared.local/r/a/conda_build_config.yaml "${ARGS[@]}" --croot ${PWD} --no-build-id 2>&1 | tee ${PWD}/python.${C_DN}.${CB_DN}.log
    done
  done

popd

