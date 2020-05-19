#!/bin/bash

set -x
set -e

if [ x"$TRAVIS" = xtrue ]; then
	CPU_COUNT=2
fi

if [ "$(uname)" = "Darwin" ]; then
    CPPFLAGS='-I$PREFIX/include -Wl,-headerpad_max_install_names'
else
    CPPFLAGS=-I$PREFIX/include
fi

CXXFLAGS=-I$PREFIX/include
mkdir build
cd build
../configure \
  --prefix=$PREFIX \
  --disable-pic14-port \
  --disable-pic16-port

make -j$CPU_COUNT
make install
