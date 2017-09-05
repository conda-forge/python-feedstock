#!/bin/bash

# Remove bzip2's shared library if present,
# as we only want to link to it statically.
# This is important in cases where conda
# tries to update bzip2.
find "${PREFIX}/lib" -name "libbz2*${SHLIB_EXT}*" | xargs rm -fv {}

python ${RECIPE_DIR}/brand_python.py

# Remove test data to save space.
# Though keep `test_support` as some things use that.
mkdir Lib/test_keep
mv Lib/test/__init__.py Lib/test_keep/
mv Lib/test/test_support.py Lib/test_keep/
rm -rf Lib/test Lib/*/test
mv Lib/test_keep Lib/test

# Remove ensurepip stubs.
rm -rf Lib/ensurepip

if [ `uname` == Darwin ]; then
    export CFLAGS="-I$PREFIX/include $CFLAGS"
    export LDFLAGS="-Wl,-rpath,$PREFIX/lib -L$PREFIX/lib -headerpad_max_install_names $LDFLAGS"
    sed -i -e "s/@OSX_ARCH@/$ARCH/g" Lib/distutils/unixccompiler.py
    ./configure \
        --enable-ipv6 \
        --enable-shared \
        --enable-unicode=ucs2 \
        --prefix=$PREFIX \
        --with-tcltk-includes="-I$PREFIX/include" \
        --with-tcltk-libs="-L$PREFIX/lib -ltcl8.5 -ltk8.5"
fi
if [ `uname` == Linux ]; then
    ./configure --enable-shared --enable-ipv6 --enable-unicode=ucs4 \
        --prefix=$PREFIX \
        --with-tcltk-includes="-I$PREFIX/include" \
        --with-tcltk-libs="-L$PREFIX/lib -ltcl8.5 -ltk8.5" \
        --enable-stacklessfewerregisters \
        CPPFLAGS="-I$PREFIX/include" \
        LDFLAGS="-L$PREFIX/lib -Wl,-rpath=$PREFIX/lib,--no-as-needed"
fi

make
make install
