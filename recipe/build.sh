#!/bin/bash

VER=${PKG_VERSION%.*}
CONDA_FORGE=no

# this is the mechanism by which we fall back to default gcc, but having it defined here can break the build
#     or use incorrect settings
unset _PYTHON_SYSCONFIGDATA_NAME
unset _CONDA_PYTHON_SYSCONFIGDATA_NAME

# Remove bzip2's shared library if present,
# as we only want to link to it statically.
# This is important in cases where conda
# tries to update bzip2.
find "${PREFIX}/lib" -name "libbz2*${SHLIB_EXT}*" | xargs rm -fv {}
# Remove openssl's shared library too. This
# is because during installation we cannot
# import hashlib until openssl and libgcc-ng
# have been installed. If this does not work
# then we will need to hack LD_LIBRARY_PATH
# to include the package cache libdir of both
# of these packages instead. A final alternative
# may be to build a static interpreter since the
# problem does not happen then.
if [[ ${HOST} =~ .*linux.* ]] || [[ ${HOST} =~ .*darwin.* ]]; then
  find "${PREFIX}/lib" -name "libssl*${SHLIB_EXT}*" | xargs rm -fv {}
  find "${PREFIX}/lib" -name "libcrypto*${SHLIB_EXT}*" | xargs rm -fv {}
fi

# Prevent lib/python${VER}/_sysconfigdata_*.py from ending up with full paths to these things
# in _build_env because _build_env will not get found during prefix replacement, only _h_env_placeh ...
AR=$(basename "${AR}")

# CC must contain the string 'gcc' or else distutils thinks it is on macOS and uses '-R' to set rpaths.
if [[ ${HOST} =~ .*darwin.* ]]; then
  CC=$(basename "${CC}")
else
  CC=$(basename "${GCC}")
fi
CXX=$(basename "${CXX}")
RANLIB=$(basename "${RANLIB}")
READELF=$(basename "${READELF}")

if [[ ${HOST} =~ .*darwin.* ]] && [[ -n ${CONDA_BUILD_SYSROOT} ]]; then
  # Python's setup.py will figure out that this is a macOS sysroot.
  CFLAGS="-isysroot ${CONDA_BUILD_SYSROOT} "${CFLAGS}
  LDFLAGS="-isysroot ${CONDA_BUILD_SYSROOT} "${LDFLAGS}
  CPPFLAGS="-isysroot ${CONDA_BUILD_SYSROOT} "${CPPFLAGS}
fi

# Debian uses -O3 then resets it at the end to -O2 in _sysconfigdata.py
export CFLAGS=$(echo "${CFLAGS}" | sed "s/-O2/-O3/g")
export CXXFLAGS=$(echo "${CXXFLAGS}" | sed "s/-O2/-O3/g")
export LDFLAGS

if [[ ${CONDA_FORGE} == yes ]]; then
  ${SYS_PYTHON} ${RECIPE_DIR}/brand_python.py
fi

export CPPFLAGS=${CPPFLAGS}" -I${PREFIX}/include"

re='^(.*)(-I[^ ]*)(.*)$'
if [[ ${CFLAGS} =~ $re ]]; then
  export CFLAGS="${BASH_REMATCH[1]}${BASH_REMATCH[3]}"
fi

if [[ ${HOST} =~ .*darwin.* ]]; then
  sed -i -e "s/@OSX_ARCH@/$ARCH/g" Lib/distutils/unixccompiler.py
  UNICODE=ucs2
elif [[ ${HOST} =~ .*linux.* ]]; then
  export LDFLAGS=${LDFLAGS}" -Wl,--no-as-needed"
  UNICODE=ucs4
fi

# This causes setup.py to query the sysroot directories from the compiler, something which
# IMHO should be done by default anyway with a flag to disable it to workaround broken ones.
# Technically, setting _PYTHON_HOST_PLATFORM causes setup.py to consider it cross_compiling
if [[ -n ${HOST} ]]; then
  if [[ ${HOST} =~ .*darwin.* ]]; then
    # Even if BUILD is .*darwin.* you get better isolation by cross_compiling (no /usr/local)
    export _PYTHON_HOST_PLATFORM=darwin
  else
    IFS='-' read -r host_arch host_vendor host_os host_libc <<<"${HOST}"
    export _PYTHON_HOST_PLATFORM=${host_os}-${host_arch}
  fi
fi


declare -a _common_configure_args
_common_configure_args+=(--prefix=${PREFIX})
_common_configure_args+=(--build=${BUILD})
_common_configure_args+=(--host=${HOST})
_common_configure_args+=(--enable-ipv6)
_common_configure_args+=(--enable-unicode=${UNICODE})
_common_configure_args+=(--with-computed-gotos)
_common_configure_args+=(--with-system-ffi)
_common_configure_args+=(--with-tcltk-includes="-I${PREFIX}/include")
_common_configure_args+=("--with-tcltk-libs=-L${PREFIX}/lib -ltcl8.6 -ltk8.6")
./configure "${_common_configure_args[@]}" \
            --enable-shared
make -j${CPU_COUNT}
make install

# Remove test data to save space
# Though keep `support` as some things use that.
# TODO :: Make a subpackage for this once we implement multi-level testing.
pushd ${PREFIX}/lib/python${VER}
  mkdir test_keep
  mv test/__init__.py test/test_support* test/script_helper* test_keep/
  rm -rf test */test
  mv test_keep test
popd

# Size reductions:
pushd ${PREFIX}
  found_lib_libpython_a=no
  if [[ -f lib/libpython${VER}.a ]]; then
    found_lib_libpython_a=yes
    chmod +w lib/libpython${VER}.a
    if [[ -n ${HOST} ]]; then
      ${HOST}-strip -S lib/libpython${VER}.a
    else
      strip -S lib/libpython${VER}.a
    fi
  fi
  CONFIG_LIBPYTHON=$(find lib/python${VER}/config -name "libpython${VER}.a")
  if [[ -f ${CONFIG_LIBPYTHON} ]]; then
    if [[ ${found_lib_libpython_a} == yes ]]; then
      chmod +w ${CONFIG_LIBPYTHON}
      rm ${CONFIG_LIBPYTHON}
      ln -s ../../libpython${VER}.a ${CONFIG_LIBPYTHON}
    else
      chmod +w ${CONFIG_LIBPYTHON}
      if [[ -n ${HOST} ]]; then
        ${HOST}-strip -S ${CONFIG_LIBPYTHON}
      else
        strip -S ${CONFIG_LIBPYTHON}
      fi
	fi
  fi
popd

# Move the _sysconfigdata.py file and replace with a version with a
# configuration more typical of what a user would expect to be in a "standard"
# python build. This results in the system toolchain and
# The original configuration with the crosstool-ng compilers from the conda
# package can be selected by setting the _PYTHON_SYSCONFIGDATA_NAME
# environmental variable to _sysconfigdata_$HOST
#   using the new compilers with python will require setting _PYTHON_SYSCONFIGDATA_NAME
#   to the name of this file (minus the .py extension)
pushd $PREFIX/lib/python${VER}
  # On Python 3.5 _sysconfigdata.py was getting copied in here and compiled for some reason.
  # This breaks our attempt to find the right one as recorded_name.
  find lib-dynload -name "_sysconfigdata*.py*" -exec rm {} \;
  recorded_name=$(find . -name "_sysconfigdata*.py")
  our_compilers_name=_sysconfigdata_$(echo ${HOST} | sed -e 's/[.-]/_/g').py
  mv ${recorded_name} ${our_compilers_name}

  # Copy all "${RECIPE_DIR}"/sysconfigdata/*.py. This is to support cross-compilation. They will be
  # from the previous build unfortunately so care must be taken at version bumps and flag changes.
  cp -rf "${RECIPE_DIR}"/sysconfigdata/*.py ${PREFIX}/lib/python${VER}/

  if [[ ${HOST} =~ .*darwin.* ]]; then
    cp ${RECIPE_DIR}/sysconfigdata/default/_sysconfigdata_osx.py ${recorded_name}
  else
    if [[ ${HOST} =~ x86_64.* ]]; then
      PY_ARCH=x86_64
    elif [[ ${HOST} =~ i686.* ]]; then
      PY_ARCH=i386
    elif [[ ${HOST} =~ powerpc64le.* ]]; then
      PY_ARCH=powerpc64le
    else
      echo "ERROR: Cannot determine PY_ARCH for host ${HOST}"
      exit 1
    fi
    cat ${RECIPE_DIR}/sysconfigdata/default/_sysconfigdata_linux.py | sed "s|@ARCH@|${PY_ARCH}|g" > ${recorded_name}
    mkdir -p ${PREFIX}/compiler_compat
    cp ${LD} ${PREFIX}/compiler_compat/ld
    echo "Files in this folder are to enhance backwards compatibility of anaconda software with older compilers."   > ${PREFIX}/compiler_compat/README
    echo "See: https://github.com/conda/conda/issues/6030 for more information."                                   >> ${PREFIX}/compiler_compat/README
  fi

  # Copy the latest sysconfigdata for this platform back to the recipe so we can do full cross-compilation
  [[ -f "${RECIPE_DIR}"/sysconfigdata/${our_compilers_name} ]] && rm -f "${RECIPE_DIR}"/sysconfigdata/${our_compilers_name}
  cat ${our_compilers_name} | sed "s|${PREFIX}|/opt/anaconda1anaconda2anaconda3|g" > "${RECIPE_DIR}"/sysconfigdata/${our_compilers_name}

popd

# https://github.com/ContinuumIO/anaconda-issues/issues/6424
# TODO :: Move this into conda-build as an error with an override (same for openssl-feedstock)
if [[ ${HOST} =~ .*linux.* ]]; then
  for _SO in lib/python2.7/lib-dynload/_ssl.so ./lib/python2.7/lib-dynload/_hashlib.so; do
    if execstack -q "${PREFIX}"/${_SO} | grep -e '^X '; then
      echo "Error, executable stack found in ${_SO}"
      exit 1
    fi
  done
fi
