#!/bin/bash
set -ex

_buildd_shared=build-shared
if [[ ${PY_INTERP_DEBUG} == yes ]]; then
  DBG=d
else
  DBG=
fi
if [[ ${PY_FREETHREADING} == yes ]]; then
  # This Python will not be usable with non-free threading Python modules.
  THREAD=t
else
  THREAD=
fi

VER=${PKG_VERSION%.*}
ABIFLAGS=${DBG}${THREAD}
VERABI=${VER}${THREAD}${DBG}
VERABI_NO_DBG=${VER}${THREAD}

# Install the shared library (for people who embed Python only, e.g. GDB).
# Linking module extensions to this on Linux is redundant (but harmless).
# Linking module extensions to this on Darwin is harmful (multiply defined symbols).
shopt -s extglob
cp -pf ${_buildd_shared}/libpython*${SHLIB_EXT}!(.lto) ${PREFIX}/lib/
shopt -u extglob
if [[ ${target_platform} =~ .*linux.* ]]; then
  ln -sf ${PREFIX}/lib/libpython${VERABI}${SHLIB_EXT}.1.0 ${PREFIX}/lib/libpython${VERABI}${SHLIB_EXT}
fi
if [[ ${PY_INTERP_DEBUG} == yes ]]; then
  ln -s ${PREFIX}/lib/libpython${VERABI}${SHLIB_EXT} ${PREFIX}/lib/libpython${VERABI_NO_DBG}${SHLIB_EXT}
fi
