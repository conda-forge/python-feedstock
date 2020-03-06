#!/usr/bin/env bash

# Only conda versions in which 'source /dev/start /opt/conda' works
# can be used here.
declare -a CONDA_VERSIONS=()
CONDA_VERSIONS+=(us/3.8.1)
CONDA_VERSIONS+=(us/3.8.2)
CONDA_VERSIONS+=(ma/master)

declare -a CONDA_BUILD_VERSIONS=()
CONDA_BUILD_VERSIONS+=(us/3.18.11)
CONDA_BUILD_VERSIONS+=(us/master)

declare -a ARGS=()
ARGS+=(--debug)

conda activate

mkdir /tmp/builds.py.c-cb
pushd /tmp/builds.py.c-cb

  for CONDA_VERSION in "${CONDA_VERSIONS[@]}"; do
    C_DN=${CONDA_VERSION//_/}
    echo "C_DN=${C_DN}"
    git clone https://github.com/mingwandroid/conda.git -o ma conda.${C_DN}
    pushd conda.${C_DN}
      git remote add us https://github.com/conda/conda.git
      git fetch us
      git checkout ${C_DN}
      source dev/start /opt/conda
    popd
    for CONDA_BUILD_VERSION in "${CONDA_BUILD_VERSIONS[@]}"; do
      CB_DN=${CONDA_BUILD_VERSION//_/}
      echo "DN=${DN}"
      git clone https://github.com/mingwandroid/conda-build.git -o ma conda-build.${CB_DN}
      pushd conda.${CB_DN}
        git remote add us https://github.com/conda/conda-build.git
        git fetch us
        git checkout ${CB_DN}
        python setup.py develop
      popd
      conda-build $(dirname ${BASH_SOURCE[0]}) "${ARGS[@]}" --croot ${PWD} 2>&1 | tee ${PWD}/python.${C_DN}.${CB_DN}
    done
  done

popd

