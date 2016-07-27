#!/bin/bash
unset MAKEFLAGS

if [ `uname` == Darwin ]; then
    ./configure --prefix=$PREFIX --with-dyld
    # fdatasync is defined on OS X but there is no header for it.
    sed -i -e "s/#define HAVE_FDATASYNC 1/#undef HAVE_FDATASYNC/" config.h
fi
if [ `uname` == Linux ]; then
    ./configure --prefix=$PREFIX
fi

# make sometimes fails to make python so explicitly make targets
make python
make sharedmods
make install

# No shared modules are compiled by default. Create an empty lib-dynload
# directory to suppress the "Could not find platform dependent libraries"
# message
mkdir -p $PREFIX/lib/python2.0/lib-dynload
touch $PREFIX/lib/python2.0/lib-dynload/empty
