#!/bin/bash

./configure --prefix=$PREFIX
# make sometimes fails to make python so explicitly make targets
make python
make sharedmods
make install

# No shared modules are compiled by default. Create an empty lib-dynload
# directory to suppress the "Could not find platform dependent libraries"
# message
mkdir -p $PREFIX/lib/python1.6/lib-dynload
touch $PREFIX/lib/python1.6/lib-dynload/empty
