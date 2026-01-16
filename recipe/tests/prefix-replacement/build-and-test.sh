#!/usr/bin/env bash

set -ex

# see bpo44182 for why -L${CONDA_PREFIX}/lib is added
${CC} a.c $(python3-config --cflags) \
    $(python3-config --embed --ldflags) \
    -L${CONDA_PREFIX}/lib -Wl,-rpath,${CONDA_PREFIX}/lib \
    -o ${CONDA_PREFIX}/bin/embedded-python-shared

if [[ "$target_platform" == linux-* ]]; then
  if ! ${READELF} -d ${CONDA_PREFIX}/bin/embedded-python-shared | rg libpython; then
    echo "ERROR :: Embedded python linked to static python library. We tried to force it to use the shared library."
  fi
elif [[ "$target_platform" == osx-* ]]; then
  if ! ${OTOOL} -l ${CONDA_PREFIX}/bin/embedded-python-shared | rg libpython; then
    echo "ERROR :: Embedded python linked to static python library. We tried to force it to use the shared library."
  fi
fi
${CONDA_PREFIX}/bin/embedded-python-shared

if [[ "$PKG_NAME" == "libpython-static" ]]; then
  # remove the shared library to force static linking
  rm -f ${CONDA_PREFIX}/lib/libpython*.{so,dylib}

  ${CC} a.c $(python3-config --cflags) \
      $(python3-config --embed --ldflags) \
      -L${CONDA_PREFIX}/lib -Wl,-rpath,${CONDA_PREFIX}/lib \
      -o ${CONDA_PREFIX}/bin/embedded-python-static
  if [[ "$target_platform" == linux-* ]]; then
    if ${READELF} -d ${CONDA_PREFIX}/bin/embedded-python-static | rg libpython; then
      echo "ERROR :: Embedded python linked to shared python library. It is expected to link to the static library."
    fi
  elif [[ "$target_platform" == osx-* ]]; then
    if ${OTOOL} -l ${CONDA_PREFIX}/bin/embedded-python-static | rg libpython; then
      echo "ERROR :: Embedded python linked to shared python library. It is expected to link to the static library."
    fi
  fi
  ${CONDA_PREFIX}/bin/embedded-python-static
fi

set +x
