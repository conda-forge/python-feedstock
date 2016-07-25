#!/bin/bash

if [ `uname` == Darwin ]; then
    # Compile with a no checking of the return type checking, note that
    # CFLAGS cannot be used here.
    export CC="gcc -Wno-return-type"
fi
./configure --prefix=$PREFIX
make
make install
