setlocal EnableDelayedExpansion
echo on
set PF=win-64
:: set PF=win-32
export CONDA_SUBDIR=%PF%

set THISD=%~dp0
set THISD=%THISD:~0,-1%

call conda activate
set CB_CROOT=!CONDA_PREFIX!\conda-bld
set CB_CROOT=%CD%\conda-bld

set PYTHONS=yes
set PIPS=yes
set LIEFS=yes
set LEVEN=yes
set THREE_SEVEN=yes
set THREE_EIGHT=yes
set DEBUG_ME=yes
set RELEASE_ME=yes

pushd %THISD%

set CB_DEBUG=--debug
:: set CB_DEBUG=
set CB_KEEP=--keep-old-work --dirty

set SKIP_BUILT=no

set DBG_CFG=%THISD%\..\conda_build_config-dbg_c-dbg_py_%PF%.yaml
set DBG_CFG=%THISD%\..\conda_build_config-dbg_%PF%.yaml
set REL_CFG=%THISD%\..\conda_build_config-%PF%.yaml
set CHANNELS=-c local -c rdonnelly -c defaults
mkdir %CB_CROOT%

if %PYTHONS%==no goto skip_pythons
  if %THREE_EIGHT%==yes (
    if %DEBUG_ME%==yes (
      if %SKIP_BUILT%==no del %CB_CROOT%\win-64\python-3.8.1-h8359038_5_cpython_dbg.tar.bz2
      if not exist %CB_CROOT%\win-64\python-3.8.1-h8359038_5_cpython_dbg.tar.bz2 (
        set PY_INTERP_DEBUG=yes
        set BLD_DIRNAME=python-dbg-3.8.1-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        echo conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !DST_DIR!\build.log
        conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !DST_DIR!\build.log
        if %errorlevel% neq 0 exit /b 1
      )
    )
    if %RELEASE_ME%==yes (
      if %SKIP_BUILT%==no del %CB_CROOT%\win-64\python-3.8.1-hfe8d314_5_cpython.tar.bz2
      if not exist %CB_CROOT%\win-64\python-3.8.1-hfe8d314_5_cpython.tar.bz2 (
        set PY_INTERP_DEBUG=
        set BLD_DIRNAME=python-3.8.1-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        echo conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !DST_DIR!\build.log
        conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !DST_DIR!\build.log
        if %errorlevel% neq 0 exit /b 1
      )
    )
  )

  if %THREE_SEVEN%==yes (
    pushd ..\..\a\python-3.7-feedstock
    if %DEBUG_ME%==yes (
      if %SKIP_BUILT%==no del %CB_CROOT%\win-64\python-3.7.6-hd0f8130_5_cpython_dbg.tar.bz2
      if not exist %CB_CROOT%\win-64\python-3.7.6-hd0f8130_5_cpython_dbg.tar.bz2 (
        set PY_INTERP_DEBUG=yes
        set BLD_DIRNAME=python-dbg-3.7.6-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        echo conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !DST_DIR!\build.log
        conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-{v}-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !DST_DIR!\build.log
        if %errorlevel% neq 0 exit /b 1
      )
    )
    if %RELEASE_ME%==yes (
      if %SKIP_BUILT%==no del %CB_CROOT%\win-64\python-3.7.6-hd0f8130_5_cpython.tar.bz2
      if not exist %CB_CROOT%\win-64\python-3.7.6-h9387f8d_5_cpython.tar.bz2 (
        set PY_INTERP_DEBUG=
        set BLD_DIRNAME=python-3.7.6-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        echo conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !DST_DIR!\build.log
        conda-build --croot %CB_CROOT% --build-id-pat {n}-{v}-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !DST_DIR!\build.log
        if %errorlevel% neq 0 exit /b 1
      )
    )
    popd
  )

:skip_pythons

if %PIPS%==no goto skip_pips
call %THISD%\build-something-debug.bat %CB_CROOT% %PF% pip ..\..\a\pip-feedstock %THREE_SEVEN% %THREE_EIGHT% %DEBUG_ME% %RELEASE_ME%
:skip_pips

if %LIEFS%==no goto skip_liefs
call %THISD%\build-something-debug.bat %CB_CROOT% %PF% lief ..\..\c.wip\lief-feedstock %THREE_SEVEN% %THREE_EIGHT% %DEBUG_ME% %RELEASE_ME%
:skip_liefs

if %LEVEN%==no goto skip_leven
call %THISD%\build-something-debug.bat %CB_CROOT% %PF% python-levenshtein ..\..\a\python-levenshtein-feedstock %THREE_SEVEN% %THREE_EIGHT% %DEBUG_ME% %RELEASE_ME%
:skip_leven

goto skip_old

if %LIEFS%==yes (
  pushd ..\..\c.wip\lief-feedstock
  if %THREE_EIGHT%==yes (
    if %DEBUG_ME%==yes (
      if not exist %CB_CROOT%\win-64\py-lief-0.10.1-py38h5824298_0_dbg.tar.bz2 and %SKIP_BUILT%==yes (
        set PY_INTERP_DEBUG=yes
        set BLD_DIRNAME=lief-dbg-3.8.1-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.8.1-%PF% -m %DBG_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
      )
    )
    if %RELEASE_ME%==yes (
      if not exist %CB_CROOT%\win-64\py-lief-0.10.1-py38h5824298_0.tar.bz2 and %SKIP_BUILT%==yes (
        set PY_INTERP_DEBUG=
        set BLD_DIRNAME=lief-3.8.1-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        conda-build --croot %CB_CROOT% --build-id-pat {n}-3.8.1-%PF% -m %REL_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
      )
    )
  )
  
  if %THREE_SEVEN%==yes (
    if %DEBUG_ME%==yes (
      if not exist %CB_CROOT%\win-64\py-lief-0.10.1-py37ha4be599_0_dbg.tar.bz2 and %SKIP_BUILT%==yes (
        set PY_INTERP_DEBUG=yes
        set BLD_DIRNAME=lief-dbg-3.7.6-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.7.6-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
      )
    )
    if %RELEASE_ME%==yes (
      if not exist %CB_CROOT%\win-64\py-lief-0.10.1-py37ha4be599_0.tar.bz2 and %SKIP_BUILT%==yes (
        set PY_INTERP_DEBUG=
        set BLD_DIRNAME=lief-3.7.6-%PF%
        set DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
        del /s /q !DST_DIR!
        mkdir !DST_DIR!
        conda-build --croot %CB_CROOT% --build-id-pat {n}-3.7.6-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
      )
    )
  )
  popd
)
popd

:skip_old

set CONDA_DLL_SEARCH_MODIFICATION_ENABLE=
set CONDA_DLL_SEARCH_MODIFICATION_DEBUG=
if %THREE_EIGHT%==no goto skip_38_2
  if %DEBUG_ME%==yes (
    call conda activate %CB_CROOT%\lief-dbg-3.8.1-win-64\_h_env
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v1.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v1.log
  )
  if %RELEASE_ME%==yes (
    call conda activate %CB_CROOT%\lief-3.8.1-win-64\_h_env
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v1.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v1.log
  )
:skip_38_2
if %THREE_SEVEN%==no goto skip_37_2
  if %DEBUG_ME%==yes (
    call conda activate %CB_CROOT%\lief-dbg-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37h5824298_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v1.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v1.log
  )
  if %RELEASE_ME%==yes (
    call conda activate %CB_CROOT%\lief-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37ha4be599_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v1.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v1.log
  )
:skip_37_2

set CONDA_DLL_SEARCH_MODIFICATION_ENABLE=1
set CONDA_DLL_SEARCH_MODIFICATION_DEBUG=1
if %THREE_EIGHT%==no goto skip_38_3
  if %DEBUG_ME%==yes (
    call conda activate %CB_CROOT%\lief-dbg-3.8.1-win-64\_h_env
    py-lief-0.10.1-py38h5824298_0.tar.bz2
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v2.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v2.log
  )
  if %RELEASE_ME%==yes (
    call conda activate %CB_CROOT%\lief-3.8.1-win-64\_h_env
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v2.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v2.log
  )
:skip_38_3
if %THREE_SEVEN%==no goto skip_37_2
  if %DEBUG_ME%==yes (
    call conda activate %CB_CROOT%\lief-dbg-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37h5824298_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v2.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v2.log
  )
  if %RELEASE_ME%==yes (
    call conda activate %CB_CROOT%\lief-3.7.6-win-64\_h_env_moved_py-lief-0.10.1-py37ha4be599_0_win-64
    python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')" 2>&1 | C:\msys32\usr\bin\tee !CONDA_PREFIX!\..\debug-v2.log
    echo ErrorLevel :: %ErrorLevel%  2>&1 | C:\msys32\usr\bin\tee -a !CONDA_PREFIX!\..\debug-v2.log
  )
:skip_37_2
