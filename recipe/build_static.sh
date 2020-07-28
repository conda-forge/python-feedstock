#!/bin/bash
set -ex

_buildd_static=build-static
_buildd_shared=build-shared
if [[ ${DEBUG_PY} == yes ]]; then
  DBG=d
else
  DBG=
fi
VER=${PKG_VERSION%.*}
VERABI=${VER}${DBG}


cp -pf ${_buildd_static}/libpython${VERABI}.a ${PREFIX}/lib/libpython3.8.a
if [[ ${HOST} =~ .*linux.* ]]; then
  pushd ${PREFIX}/lib/python${VER}/config-${VER}-x86_64-linux-gnu
elif [[ ${HOST} =~ .*darwin.* ]]; then
  pushd ${PREFIX}/lib/python3.8/config-3.8-darwin
fi
ln -s ${PREFIX}/lib/libpython3.8.a
popd
# If the LTO info in the normal lib is problematic (using different compilers for example
# we also provide a 'nolto' version).
cp -pf ${_buildd_shared}/libpython${VERABI}-pic.a ${PREFIX}/lib/libpython${VERABI}.nolto.a
