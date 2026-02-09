# https://scikit-build-core.readthedocs.io/en/latest/guide/cmakelists.html#finding-python

cmake_minimum_required(VERSION 3.10)
enable_language(C)
project(mymath)

option(PY_VER "Python version to use")
option(EXTRA_COMPONENTS "Additional Python components to check for")

find_package(Python ${PY_VER} COMPONENTS Interpreter ${EXTRA_COMPONENTS} REQUIRED)
