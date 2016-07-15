#!/bin/bash

if [ `uname` == Darwin ]; then

    # The OS X filesystem is case insensitive which causes various problems
    # during the build.

    # For starters conda build cannot unpack the .tar.gz file as it contains
    # files which differ only in case.
    # Perform downloading, unpacking and patching manually
    curl http://legacy.python.org/download/releases/src/python1.0.1.tar.gz \
        > python1.0.1.tar.gz
    tar xzf python1.0.1.tar.gz
    cd python-1.0.1
    patch -p0 < $RECIPE_DIR/fileobject_getline.patch

    # Compile with a no checking of the return type checking, note that
    # CFLAGS cannot be used here.
    export CC="gcc -Wno-return-type"
    ./configure --prefix=$PREFIX
    make

    # The python binary should be copied out of the Python directory during the
    # make step but this silently fails as the name conflicts with the existing
    # Python directory.
    # Perform the install manually from the Python directory
    mkdir -p $PREFIX/bin
    install -c Python/python $PREFIX/bin/python

    mkdir -p $PREFIX/lib/python
    make libinstall
fi

if [ `uname` == Linux ]; then
    ./configure --prefix=$PREFIX
    make
    make install
    # make libinstall does not create the /lib/python directory so do it
    # explicitly
    mkdir -p $PREFIX/lib/python
    make libinstall
fi
