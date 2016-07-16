#!/bin/bash

if [ `uname` == Darwin ]; then

    # The OS X filesystem is case insensitive which causes various problems
    # during the build.

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

    # make libinstall compiles the standard library with the python binary in
    # the root directory, move it there after making room by removing the
    # Python directory
    cp Python/python python_temp
    rm -rf Python
    mv python_temp python
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
