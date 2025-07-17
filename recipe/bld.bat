@echo on

setlocal EnableDelayedExpansion

if "%mpi%" NEQ "" if "%mpi%" NEQ "nompi" (
  set "CC=mpicc"
  set "CXX=mpicxx"
)

set "BUILD_DIR=%SRC_DIR%\build_shared"
mkdir "%BUILD_DIR%"
cd "%BUILD_DIR%"

cmake %CMAKE_ARGS% ^
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_C_COMPILER=%CC% ^
    -DCMAKE_CXX_COMPILER=%CXX% ^
    -DBUILD_SHARED_LIBS=ON ^
    -DNCXX_ENABLE_TESTS=OFF ^
    -DENABLE_DOXYGEN=OFF ^
    -DHDF5_ROOT=%LIBRARY_PREFIX% ^
    -DHDF5_INCLUDE_DIRS=%LIBRARY_INC% ^
    -DHDF5_C_INCLUDE_DIR=%LIBRARY_INC% ^
    -DHDF5_C_INCLUDE_DIRS=%LIBRARY_INC% ^
    -DHDF5_LIBRARIES=%LIBRARY_LIB%\hdf5.lib ^
    -DHDF5_C_LIBRARIES=%LIBRARY_LIB%\hdf5.lib ^
    -DHDF5_HL_LIBRARIES="%LIBRARY_LIB%\hdf5_hl.lib;%LIBRARY_LIB%\hdf5.lib" ^
    -DHDF5_C_HL_LIBRARIES="%LIBRARY_LIB%\hdf5_hl.lib;%LIBRARY_LIB%\hdf5.lib" ^
    "%SRC_DIR%"

cmake --build . --config Release --target install

REM Create symbolic link if necessary (Windows equivalent, copying instead of linking)
copy "%LIBRARY_LIB%\netcdf-cxx4.lib" "%LIBRARY_LIB%\netcdf_c++4.lib"