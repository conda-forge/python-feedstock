#!/usr/bin/env bash

_PF=win-64
# _PF=win-32
export CONDA_SUBDIR=${_PF}

_THISD=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))

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

pushd ${_THISD} > /dev/null 2>&1

# _CB_DEBUG=--debug
_CB_DEBUG=
_CB_KEEP="--keep-old-work --dirty"

_SKIP_BUILT=no

# _DBG_CFG=${_THISD}/../conda_build_config-dbg_c-dbg_py_${_PF}.yaml
_DBG_CFG=${_THISD}/../conda_build_config-dbg_${_PF}.yaml
_REL_CFG=${_THISD}/../conda_build_config-_${_PF}.yaml
_CHANNELS="-c local -c rdonnelly -c defaults"
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

