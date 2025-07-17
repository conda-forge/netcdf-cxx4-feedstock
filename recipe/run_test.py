# Load the libraries using ctypes.
import os
import sys
import ctypes

platform = sys.platform

if platform.startswith('linux'):
    path = os.path.join(sys.prefix, 'lib', 'libnetcdf-cxx4.so')
    lib = ctypes.CDLL(path)
    path = os.path.join(sys.prefix, 'lib', 'libnetcdf_c++4.so')
    lib = ctypes.CDLL(path)
elif platform == 'darwin':
    path = os.path.join(sys.prefix, 'lib', 'libnetcdf-cxx4.dylib')
    lib = ctypes.CDLL(path)
    path = os.path.join(sys.prefix, 'lib', 'libnetcdf_c++4.dylib')
    lib = ctypes.CDLL(path)
elif platform == 'win32':
    path = os.path.join(sys.prefix, 'Library', 'bin', 'netcdf-cxx4.dll')
    lib = ctypes.CDLL(path)
    path = os.path.join(sys.prefix, 'Library', 'bin', 'netcdf_c++4.dll')
    lib = ctypes.CDLL(path)
else:
    raise ValueError('Unrecognized platform: {}'.format(platform))
