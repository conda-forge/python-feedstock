#!/bin/bash

./configure --prefix=$PREFIX
make
make install
# make libinstall does not create the /lib/python directory so do it explicitly
mkdir -p $PREFIX/lib/python
make libinstall
