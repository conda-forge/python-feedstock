#!/usr/bin/env bash

if [[ $(uname) =~ M.* ]]; then
  _PF=win-64
  # _PF=win-32
  _PF_CBC=_${_PF}
elif [[ $(uname) == Darwin ]]; then
  _PF=osx-64
else
  _PF=linux-64
fi
export CONDA_SUBDIR=${_PF}

_THISD=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
if [[ -z ${_THISD} ]]; then
  _THISD=$(dirname "${BASH_SOURCE[0]}")
fi

conda activate
_CB_CROOT=${PWD}/conda-bld

_PYTHONS=yes
_PIPS=yes
_LIEFS=yes
_LEVEN=no
_THREE_SEVEN=no
_THREE_EIGHT=yes
_DEBUG_ME=yes
_RELEASE_ME=yes

# This is very important
conda config --set add_pip_as_python_dependency False

pushd ${_THISD} > /dev/null 2>&1

# _CB_DEBUG=--debug
_CB_DEBUG=
_CB_KEEP="--keep-old-work --dirty"

_SKIP_BUILT=no

# _DBG_CFG=${_THISD}/../conda_build_config-dbg_c-dbg_py${_PF_CBC}.yaml
_DBG_CFG=${_THISD}/../conda_build_config-dbg${_PF_CBC}.yaml
_REL_CFG=${_THISD}/../conda_build_config-${_PF_CBC}.yaml
if [[ $(uname) == Darwin ]]; then
  # The clang on rdonnelly is 9, and has no ar nor deps on cctools/ld64.
  _CHANNELS="-c local -c defaults"
else
  _CHANNELS="-c local -c rdonnelly -c defaults"
fi
mkdir ${_CB_CROOT} > /dev/null 2>&1 || true

if [[ ${_PYTHONS} == yes ]]; then
  if [[ ${_THREE_EIGHT} == yes ]]; then
    if [[ ${_DEBUG_ME} == yes ]]; then
      if [[ ${_SKIP_BUILT} == no ]]; then
        rm -rf ${_CB_ROOT}/conda-bld/python-dbg-3.8*
        rm -rf ${_CB_ROOT}/${_PF}/python-3.8.*
      fi
      if [[ ! -f ${_CB_ROOT}/${_PF}/python-3.8.* ]]; then
        export PY_INTERP_DEBUG=yes
        _BLD_DIRNAME=python-dbg-3.8.2-${_PF}
        _DST_DIR=${_CB_CROOT}/${_BLD_DIRNAME}
        rm -rf ${_DST_DIR}
        mkdir -p ${_DST_DIR} || true
        echo "conda-build --croot ${_CB_CROOT} --build-id-pat {n}-dbg-{v}-${_PF} -m ${_DBG_CFG} ${_THISD} --python 3.8 ${_CHANNELS} ${_CB_KEEP} ${_CB_DEBUG} | tee ${_DST_DIR}/build.log"
        conda-build --croot ${_CB_CROOT} --build-id-pat {n}-dbg-{v}-${_PF} -m ${_DBG_CFG} ${_THISD} --python 3.8 ${_CHANNELS} ${_CB_KEEP} ${_CB_DEBUG} 2>&1 | tee ${_DST_DIR}/build.log
        if [[ $? != 0 ]]; then
          echo "ERROR :: Failed to build python 3.8"
          exit 1
        fi
      fi
    fi
  fi
fi

