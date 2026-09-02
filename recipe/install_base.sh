#!/bin/bash
set -ex

if [[ ! -d ${SRC_DIR}/python-bin ]]; then
  # Need an up-to-date python to build python.
  # python 3.10 in miniforge is too old.
  CONDA_SUBDIR=$build_platform conda create -p ${SRC_DIR}/python-bin python -c conda-forge --override-channels --yes --quiet
  export PATH=${SRC_DIR}/python-bin/bin:${PATH}
fi

VER=${PKG_VERSION%.*}

_buildd_static=build-static
_buildd_shared=build-shared

# For debugging builds, set this to no to disable profile-guided optimization
if [[ ${PY_INTERP_DEBUG} == yes ]]; then
  _OPTIMIZED=no
  DBG=d
else
  _OPTIMIZED=yes
  DBG=
fi

if [[ ${PY_FREETHREADING} == yes ]]; then
  # This Python will not be usable with non-free threading Python modules.
  THREAD=t
else
  THREAD=
fi

VERABI=${VER}${THREAD}${DBG}
VERABI_NO_DBG=${VER}${THREAD}

# This is the mechanism by which we fall back to default gcc, but having it defined here
# would probably break the build by using incorrect settings and/or importing files that
# do not yet exist.
unset _PYTHON_SYSCONFIGDATA_NAME
unset _CONDA_PYTHON_SYSCONFIGDATA_NAME

declare -a LTO_CFLAGS=()
if [[ ${_OPTIMIZED} == yes ]]; then
  if [[ ${CC} =~ .*gcc.* ]]; then
    LTO_CFLAGS+=(-fuse-linker-plugin)
    LTO_CFLAGS+=(-ffat-lto-objects)
    # -flto must come after -flto-partition due to the replacement code
    # TODO :: Replace the replacement code using conda-build's in-build regex replacement.
    LTO_CFLAGS+=(-flto-partition=none)
    LTO_CFLAGS+=(-flto)
  else
    # TODO :: Check if -flto=thin gives better results. It is about faster
    #         compilation rather than faster execution so probably not:
    # http://clang.llvm.org/docs/ThinLTO.html
    # http://blog.llvm.org/2016/06/thinlto-scalable-and-incremental-lto.html
    LTO_CFLAGS+=(-flto)
  fi
fi

make -C ${_buildd_static} install

declare -a _FLAGS_REPLACE=()
if [[ ${_OPTIMIZED} == yes ]]; then
  _FLAGS_REPLACE+=(-O3)
  _FLAGS_REPLACE+=(-O2)
  _FLAGS_REPLACE+=("-fprofile-use")
  _FLAGS_REPLACE+=("")
  _FLAGS_REPLACE+=("-fprofile-correction")
  _FLAGS_REPLACE+=("")
  _FLAGS_REPLACE+=("-L.")
  _FLAGS_REPLACE+=("")
  for _LTO_CFLAG in "${LTO_CFLAGS[@]}"; do
    _FLAGS_REPLACE+=(${_LTO_CFLAG})
    _FLAGS_REPLACE+=("")
  done
fi

SYSCONFIG=$(find ${_buildd_static}/$(cat ${_buildd_static}/pybuilddir.txt) -name "_sysconfigdata*.py" -print0)
cat ${SYSCONFIG} | ${SYS_PYTHON} "${RECIPE_DIR}"/replace-word-pairs.py \
  "${_FLAGS_REPLACE[@]}"  \
    > ${PREFIX}/lib/python${VERABI_NO_DBG}/$(basename ${SYSCONFIG})
MAKEFILE=$(find ${PREFIX}/lib/python${VERABI_NO_DBG}/ -path "*config-*/Makefile" -print0)
cp ${MAKEFILE} /tmp/Makefile-$$
cat /tmp/Makefile-$$ | ${SYS_PYTHON} "${RECIPE_DIR}"/replace-word-pairs.py \
  "${_FLAGS_REPLACE[@]}"  \
    > ${MAKEFILE}
# Check to see that our differences took.
# echo diff -urN ${SYSCONFIG} ${PREFIX}/lib/python${VERABI_NO_DBG}/$(basename ${SYSCONFIG})
# diff -urN ${SYSCONFIG} ${PREFIX}/lib/python${VERABI_NO_DBG}/$(basename ${SYSCONFIG})

# Python installs python${VER}m and python${VER}, one as a hardlink to the other. conda-build breaks these
# by copying. Since the executable may be static it may be very large so change one to be a symlink
# of the other. In this case, python${VER}m will be the symlink.
if [[ -f ${PREFIX}/bin/python${VER}m ]]; then
  rm -f ${PREFIX}/bin/python${VER}m
  ln -s ${PREFIX}/bin/python${VER} ${PREFIX}/bin/python${VER}m
fi
ln -s ${PREFIX}/bin/python${VER} ${PREFIX}/bin/python
ln -s ${PREFIX}/bin/pydoc${VER} ${PREFIX}/bin/pydoc
# Workaround for https://github.com/conda/conda/issues/10969
ln -s ${PREFIX}/bin/python${VER} ${PREFIX}/bin/python3.1

# Remove test data to save space
# Though keep `support` as some things use that.
# TODO :: Make a subpackage for this once we implement multi-level testing.
pushd ${PREFIX}/lib/python${VERABI_NO_DBG}
  mkdir test_keep
  mv test/__init__.py test/support test/test_support* test/test_script_helper* test_keep/
  rm -rf test */test
  mv test_keep test
popd

# Size reductions:
pushd ${PREFIX}
  if [[ -f lib/libpython${VERABI}.a ]]; then
    chmod +w lib/libpython${VERABI}.a
    ${STRIP} -S lib/libpython${VERABI}.a
  fi
  CONFIG_LIBPYTHON=$(find lib/python${VERABI_NO_DBG}/config-${VERABI}* -name "libpython${VERABI}.a")
  if [[ -f lib/libpython${VERABI}.a ]] && [[ -f ${CONFIG_LIBPYTHON} ]]; then
    chmod +w ${CONFIG_LIBPYTHON}
    rm ${CONFIG_LIBPYTHON}
  fi
popd

# Copy sysconfig that gets recorded to a non-default name
# using the new compilers with python will require setting _PYTHON_SYSCONFIGDATA_NAME
# to the name of this file (minus the .py extension)
pushd "${PREFIX}"/lib/python${VERABI_NO_DBG}
  # On Python 3.5 _sysconfigdata.py was getting copied in here and compiled for some reason.
  # This breaks our attempt to find the right one as recorded_name.
  find lib-dynload -name "_sysconfigdata*.py*" -exec rm {} \;
  recorded_name=$(find . -name "_sysconfigdata*.py")
  our_compilers_name=_sysconfigdata_$(echo ${HOST} | sed -e 's/[.-]/_/g').py
  # So we can see if anything has significantly diverged by looking in a built package.
  cp ${recorded_name} ${recorded_name}.orig
  cp ${recorded_name} sysconfigfile
  # fdebug-prefix-map for python work dir is useless for extensions
  sed -i.bak "s@-fdebug-prefix-map=$SRC_DIR=/usr/local/src/conda/python-$PKG_VERSION@@g" sysconfigfile
  sed -i.bak "s@-fdebug-prefix-map=$PREFIX=/usr/local/src/conda-prefix@@g" sysconfigfile
  # Append the conda-forge zoneinfo to the end
  sed -i.bak "s@zoneinfo'@zoneinfo:$PREFIX/share/tzinfo'@g" sysconfigfile
  # Remove osx sysroot as it depends on the build machine
  # be sure CONDA_BUILD_SYSROOT has value, as other we will remove here instead spaces
  if [[ "${target_platform}" == osx-* ]] && [[ -n ${CONDA_BUILD_SYSROOT} ]]; then
    sed -i.bak "s@-isysroot @@g" sysconfigfile
    sed -i.bak "s@$CONDA_BUILD_SYSROOT @@g" sysconfigfile
  fi
  # Remove unfilled config option
  sed -i.bak "s/@SGI_ABI@//g" sysconfigfile
  sed -i.bak "s@$BUILD_PREFIX/bin/${HOST}-llvm-ar@${HOST}-ar@g" sysconfigfile
  # Remove GNULD=yes to make sure new-dtags are not used
  sed -i.bak "s/'GNULD': 'yes'/'GNULD': 'no'/g" sysconfigfile
  cp sysconfigfile ${our_compilers_name}

  # For system gcc remove the triple
  sed -i.bak "s@$HOST-c++@g++@g" sysconfigfile
  sed -i.bak "s@$HOST-@@g" sysconfigfile
  if [[ "$target_platform" == linux* ]]; then
    # For linux, make sure the system gcc uses our linker
    sed -i.bak "s@-pthread@-pthread -B $PREFIX/share/python_compiler_compat@g" sysconfigfile
  fi
  # Don't set -march and -mtune for system gcc
  sed -i.bak "s@-march=[^( |\\\"|\\\')]*@@g" sysconfigfile
  sed -i.bak "s@-mtune=[^( |\\\"|\\\')]*@@g" sysconfigfile
  # Remove these flags that older compilers and linkers may not know
  for flag in "-fstack-protector-strong" "-ffunction-sections" "-pipe" "-fno-plt" \
            "-ftree-vectorize" "-Wl,--sort-common" "-Wl,--as-needed" "-Wl,-z,relro" \
            "-Wl,-z,now" "-Wl,--disable-new-dtags" "-Wl,--gc-sections" "-Wl,-O2" \
            "-fPIE" "-ftree-vectorize" "-mssse3" "-Wl,-pie" "-Wl,-dead_strip_dylibs" \
            "-Wl,-headerpad_max_install_names"; do
    sed -i.bak "s@$flag@@g" sysconfigfile
  done
  # Cleanup some extra spaces from above
  sed -i.bak "s@' [ ]*@'@g" sysconfigfile
  cp sysconfigfile $recorded_name
  echo "========================sysconfig==========================="
  cat $recorded_name
  echo "============================================================"

  rm sysconfigfile
  rm sysconfigfile.bak
popd

if [[ ${HOST} =~ .*linux.* ]]; then
  mkdir -p ${PREFIX}/share/python_compiler_compat
  ln -s ${PREFIX}/bin/${HOST}-ld ${PREFIX}/share/python_compiler_compat/ld
  echo "Files in this folder are to enhance backwards compatibility of anaconda software with older compilers."   > ${PREFIX}/share/python_compiler_compat/README
  echo "See: https://github.com/conda/conda/issues/6030 for more information."                                   >> ${PREFIX}/share/python_compiler_compat/README
fi

python -c "import compileall,os;compileall.compile_dir(os.environ['PREFIX'])"
rm ${PREFIX}/lib/libpython${VERABI}.a

if [[ ${PY_INTERP_DEBUG} == yes ]]; then
  rm ${PREFIX}/bin/python${VER}
  ln -s ${PREFIX}/bin/python${VERABI} ${PREFIX}/bin/python${VER}
  ln -s ${PREFIX}/include/python${VERABI} ${PREFIX}/include/python${VER}
fi

if [[ "$target_platform" == linux-* ]]; then
  rm ${PREFIX}/include/uuid.h
fi

# Workaround for https://github.com/conda/conda/issues/14053
# Older conda versions install noarch: python packages in wrong places.
# For example python3.1 because older conda assumed python minor version
# will have only one digit. noarhc pkgs for freethreading builds are supposed
# to be installed into <prefix>/lib/python3.13t/site-packages, but conda
# installs them to <prefix>/lib/python3.13/site-packages.
# The workaround is to add all these wrong paths to sys.path using
# a pth file so that cpython and other tools like pip know about these
# locations to check when importing packages and uninstalling packages.
# When installing packages, pip will use the correct location
# <prefix>/lib/python3.13t/site-packages.
# Note that these directories are not added to sys.path if they do not exist.
SP_DIR="${PREFIX}/lib/python${PY_VER}${THREAD}/site-packages"
if [[ ${PY_FREETHREADING} == yes ]]; then
    echo "${PREFIX}/lib/python${PY_VER}/site-packages" >> $SP_DIR/conda-site.pth
fi
# Workaround for https://github.com/conda/conda/issues/10969
echo "${PREFIX}/lib/python3.1/site-packages" >> $SP_DIR/conda-site.pth
# A python version independent directory that ABI3 and noarch packages can use.
# This is unused at the moment, but keeping it here for experimentation.
echo "${PREFIX}/lib/python/site-packages" >> $SP_DIR/conda-site.pth
