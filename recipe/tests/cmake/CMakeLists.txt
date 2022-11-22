# https://martinopilia.com/posts/2018/09/15/building-python-extension.html
# FindPythonInterp and FindPythonLibs is deprecated since cmake 3.12

cmake_minimum_required(VERSION 3.10)
enable_language(C)
project(mymath)

option(PY_VER, "Python version to use")
find_package(Python ${PY_VER} REQUIRED)
