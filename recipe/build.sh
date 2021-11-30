#!/usr/bin/env bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ -n "$mpi" && "$mpi" != "nompi" ]]; then
  export CC=mpicc
  export CXX=mpicxx
fi

if [ $(uname) == Darwin ]; then
  export CXX="${CXX} -stdlib=libc++"
fi

# Build shared library using cmake
# works for both linux and osx, but missing ncxx4-config
# see https://github.com/Unidata/netcdf-cxx4/issues/36

# Build static.
mkdir build_static && cd build_static
cmake ${CMAKE_ARGS} -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D CMAKE_INSTALL_LIBDIR:PATH=$PREFIX/lib \
      -D BUILD_SHARED_LIBS=OFF \
      -D NCXX_ENABLE_TESTS=ON \
      -D ENABLE_DOXYGEN=OFF \
      $SRC_DIR
make
# ctest  # Run only for the shared lib build to save time.
make install


make clean

cd ..

# Build shared.
mkdir build_shared && cd build_shared
cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D CMAKE_INSTALL_LIBDIR:PATH=$PREFIX/lib \
      -D BUILD_SHARED_LIBS=ON \
      -D NCXX_ENABLE_TESTS=ON \
      -D ENABLE_DOXYGEN=OFF \
      $SRC_DIR
make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest
fi
make install

# Workaround cmake's libnetcdf-cxx4 and configure's libnetcdf_c++4.
for fname in $PREFIX/lib/libnetcdf-cxx4.*; do
  ln -s $fname $PREFIX/lib/libnetcdf_c++4.${fname#*.}
done

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
