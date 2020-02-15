set PF=win-32
set PF=win-64
set OLDCD=%~dp0

set CB_DEBUG=--debug
set CB_DEBUG= 

set DBG_CFG=conda_build_config-dbg_c-dbg_py.yaml
set DBG_CFG=conda_build_config-dbg.yaml
set REL_CFG=conda_build_config-win64.yaml
set CHANNELS=-c local -c rdonnelly -c defaults
call conda activate
set CB_CROOT=%CONDA_PREFIX%\conda-bld
set CB_ROOT=%CD%\conda-bld
mkdir %CB_ROOT%

set PY_INTERP_DEBUG=yes
set BLD_DIRNAME=python-dbg-3.8.1-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m ..\..\a\%DBG_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log

set PY_INTERP_DEBUG=
set BLD_DIRNAME=python-3.8.1-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m ..\..\a\%REL_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log

cd ..\..\..\r\a\python-3.7-feedstock

set PY_INTERP_DEBUG=yes
set BLD_DIRNAME=python-dbg-3.7.6-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m ..\..\a\%DBG_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log

set PY_INTERP_DEBUG=
set BLD_DIRNAME=python-3.7.6-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m ..\..\a\%REL_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log


cd ..\..\..\r\c.wip\lief-feedstock

set PY_INTERP_DEBUG=yes
set BLD_DIRNAME=lief-dbg-3.8.1-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.8.1-%PF% -m ..\..\a\%DBG_CFG% . --python 3.8 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log

set PY_INTERP_DEBUG=
set BLD_DIRNAME=lief-3.8.1-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-3.8.1-%PF% -m ..\..\a\%REL_CFG% . --python 3.8 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log

set PY_INTERP_DEBUG=yes
set BLD_DIRNAME=lief-dbg-3.7.6-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.7.6-%PF% -m ..\..\a\%DBG_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log

set PY_INTERP_DEBUG=
set BLD_DIRNAME=lief-3.7.6-%PF%
set DST_DIR=%CB_CROOT%\%BLD_DIRNAME%
del /s /q %DST_DIR%
mkdir %DST_DIR%
conda-build --croot %CB_CROOT% --build-id-pat {n}-3.7.6-%PF% -m ..\..\a\%REL_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log


cd %OLDCD%
set CONDA_DLL_SEARCH_MODIFICATION_ENABLE=1
set CONDA_DLL_SEARCH_MODIFICATION_DEBUG=1

conda activate C:\opt\conda\conda-bld\lief-dbg-3.8.1-win-64\_h_env
python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')"

conda activate C:\opt\conda\conda-bld\lief-3.8.1-win-64\_h_env
python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')"

conda activate C:\opt\conda\conda-bld\lief-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37ha925a31_0_win-64
python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')"

conda activate C:\opt\conda\conda-bld\lief-dbg-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37h5824298_0_win-64
python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')"
