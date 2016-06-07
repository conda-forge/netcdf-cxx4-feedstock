#!/usr/bin/env bash

# Build shared library using cmake
# works for both linux and osx, but missing ncxx4-config
# see https://github.com/Unidata/netcdf-cxx4/issues/36
cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D CMAKE_INSTALL_LIBDIR:PATH=$PREFIX/lib \
      -D BUILD_SHARED_LIBS=ON \
      -D NCXX_ENABLE_TESTS=ON \
      -D ENABLE_DOXYGEN=OFF \
      $SRC_DIR
make
ctest
make install
