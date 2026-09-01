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

# create libpython3.dylib; linux builds only add this in release mode, do the same on osx
if [[ "$target_platform" == osx-* && ${PY_INTERP_DEBUG} == no ]]; then
  # need to filter out windows-specific symbols & PyOS_CheckStack from
  # https://github.com/python/cpython/blob/main/Doc/data/stable_abi.dat
  awk -F',' '
    ($1 == "func" || $1 == "data") &&
    $4 != "on Windows" &&
    $2 != "PyOS_CheckStack" {
      print "_" $2
    }
  ' Doc/data/stable_abi.dat > stable_abi_exports.txt

  $CC -dynamiclib \
   -install_name @rpath/libpython3.dylib \
   -compatibility_version 3.0 -current_version ${PY_VER}.0 \
   -Wl,-reexport_library,${PREFIX}/lib/libpython${VERABI}.dylib \
   -Wl,-exported_symbols_list,stable_abi_exports.txt \
   -o ${PREFIX}/lib/libpython3.dylib
fi
