set PF=win-32
set PF=win-64
set THISD=%~dp0
set THISD=%~dp0
set THISD=%THISD:~0,-1%

call conda activate
set CB_CROOT=%CONDA_PREFIX%\conda-bld
set CB_CROOT=%CD%\conda-bld

set THREE_SEVEN=yes
set THREE_EIGHT=yes
set DEBUG_ME=yes
set RELEASE_ME=yes

set THREE_SEVEN=no
set THREE_EIGHT=yes
set DEBUG_ME=yes
set RELEASE_ME=no

pushd %THISD%

set CB_DEBUG=--debug
set CB_DEBUG= 

set DBG_CFG=%THISD%\..\conda_build_config-dbg_c-dbg_py.yaml
set DBG_CFG=%THISD%\..\conda_build_config-dbg.yaml
set REL_CFG=%THISD%\..\conda_build_config-win64.yaml
set CHANNELS=-c local -c rdonnelly -c defaults
mkdir %CB_CROOT%

if %THREE_EIGHT%==yes (
  if %DEBUG_ME%==yes (
    set PY_INTERP_DEBUG=yes
    set BLD_DIRNAME=python-dbg-3.8.1-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
  if %RELEASE_ME%==yes (
    set PY_INTERP_DEBUG=
    set BLD_DIRNAME=python-3.8.1-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
)


if %THREE_SEVEN%==yes (
  if %DEBUG_ME%==yes (
    cd ..\..\a\python-3.7-feedstock
    set PY_INTERP_DEBUG=yes
    set BLD_DIRNAME=python-dbg-3.7.6-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
  if %RELEASE_ME%==yes (
    set PY_INTERP_DEBUG=
    set BLD_DIRNAME=python-3.7.6-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
)

cd ..\..\c.wip\lief-feedstock

if %THREE_EIGHT%==yes (
  if %DEBUG_ME%==yes (
    set PY_INTERP_DEBUG=yes
    set BLD_DIRNAME=lief-dbg-3.8.1-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.8.1-%PF% -m %DBG_CFG% . --python 3.8 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
  if %RELEASE_ME%==yes (
    set PY_INTERP_DEBUG=
    set BLD_DIRNAME=lief-3.8.1-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-3.8.1-%PF% -m %REL_CFG% . --python 3.8 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
)

if %THREE_SEVEN%==yes (
  if %DEBUG_ME%==yes (
    set PY_INTERP_DEBUG=yes
    set BLD_DIRNAME=lief-dbg-3.7.6-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.7.6-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
  if %RELEASE_ME%==yes (
    set PY_INTERP_DEBUG=
    set BLD_DIRNAME=lief-3.7.6-%PF%
    set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
    del /s /q %DST_DIR%
    mkdir %DST_DIR%
    conda-build --croot %CB_CROOT% --build-id-pat {n}-3.7.6-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %DST_DIR%\build.log
  )
)

popd

set CONDA_DLL_SEARCH_MODIFICATION_ENABLE=
set CONDA_DLL_SEARCH_MODIFICATION_DEBUG=
if %THREE_EIGHT%==yes (
  if %DEBUG_ME%==yes (
    conda activate %CB_CROOT%\lief-dbg-3.8.1-win-64\_h_env
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v1.log
  )
  if %RELEASE_ME%==yes (
    conda activate %CB_CROOT%\lief-3.8.1-win-64\_h_env
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v1.log
  )
)
if %THREE_SEVEN%==yes (
  if %DEBUG_ME%==yes (
    conda activate %CB_CROOT%\lief-dbg-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37h5824298_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v1.log
  )
  if %RELEASE_ME%==yes (
    conda activate %CB_CROOT%\lief-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37ha925a31_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v1.log
  )
)

set CONDA_DLL_SEARCH_MODIFICATION_ENABLE=1
set CONDA_DLL_SEARCH_MODIFICATION_DEBUG=1
if %THREE_EIGHT%==yes (
  if %DEBUG_ME%==yes (
    conda activate %CB_CROOT%\lief-dbg-3.8.1-win-64\_h_env
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v2.log
  )
  if %RELEASE_ME%==yes (
    conda activate %CB_CROOT%\conda-bld\lief-3.8.1-win-64\_h_env
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v2.log
  )
)
if %THREE_SEVEN%==yes (
  if %DEBUG_ME%==yes (
    conda activate %CB_CROOT%\conda-bld\lief-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37ha925a31_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v2.log
  )
  if %RELEASE_ME%==yes (
    conda activate %CB_CROOT%\conda-bld\lief-dbg-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37h5824298_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\debug-v2.log
  )
)
