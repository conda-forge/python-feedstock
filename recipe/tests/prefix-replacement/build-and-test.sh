#!/usr/bin/env bash

set -x

${CC} a.c $(python3-config --cflags) $(python3-config --ldflags) -o ${CONDA_PREFIX}/bin/embedded-python-static
if ${READELF} -d ${CONDA_PREFIX}/bin/embedded-python-static | rg libpython; then
  echo "ERROR :: Embedded python linked to shared python library. It is expected to link to the static library."
fi
${CONDA_PREFIX}/bin/embedded-python-static

# I thought this would prefer the shared library for Python. I was wrong:
# EMBED_LDFLAGS=$(python3-config --ldflags)
# re='^(.*)(-lpython[^ ]*)(.*)$'
# if [[ ${EMBED_LDFLAGS} =~ $re ]]; then
#   EMBED_LDFLAGS="${BASH_REMATCH[1]} ${BASH_REMATCH[3]} -Wl,-Bdynamic ${BASH_REMATCH[2]}"
# fi
# ${CC} a.c $(python3-config --cflags) ${EMBED_LDFLAGS} -o ${CONDA_PREFIX}/bin/embedded-python-shared

# Brute-force way of linking to the shared library, sorry!
rm -rf ${CONDA_PREFIX}/lib/libpython*.a

${CC} a.c $(python3-config --cflags) $(python3-config --ldflags) -o ${CONDA_PREFIX}/bin/embedded-python-shared
if [[ -n ${READELF} ]]; then
  if ! ${READELF} -d ${CONDA_PREFIX}/bin/embedded-python-shared | rg libpython; then
    echo "ERROR :: Embedded python linked to static python library. We tried to force it to use the shared library."
  fi
elif [[ -n ${OTOOL} ]]; then
  if ! ${OTOOL} -l ${CONDA_PREFIX}/bin/embedded-python-shared | rg libpython; then
    echo "ERROR :: Embedded python linked to static python library. We tried to force it to use the shared library."
  fi
fi
${CONDA_PREFIX}/bin/embedded-python-shared

set +x
