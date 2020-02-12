set PF=win-32
set PF=win-64
set OLDCD=%~dp0
set CB_DEBUG=--debug
set CB_DEBUG=

call conda activate

:: set PY_INTERP_DEBUG=yes
:: del /s /q %CONDA_PREFIX%\conda-bld\python
:: del /s /q %CONDA_PREFIX%\conda-bld\python-3.8-dbg-%PF%
:: mkdir %CONDA_PREFIX%\conda-bld\python
:: conda-build -m ..\..\a\conda_build_config-dbg.yaml . --python 3.7 --no-build-id -c rdonnelly --keep-old-work --dirty 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\conda-bld\python\build.log
:: move %CONDA_PREFIX%\conda-bld\python %CONDA_PREFIX%\conda-bld\python-3.8-dbg-%PF%
:: 
:: set PY_INTERP_DEBUG=
:: del /s /q %CONDA_PREFIX%\conda-bld\python
:: del /s /q %CONDA_PREFIX%\conda-bld\python-3.8-%PF%
:: mkdir %CONDA_PREFIX%\conda-bld\python
:: conda-build -m ..\..\a\conda_build_config.yaml . --python 3.7 --no-build-id -c rdonnelly --keep-old-work --dirty 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\conda-bld\python\build.log
:: move %CONDA_PREFIX%\conda-bld\python %CONDA_PREFIX%\conda-bld\python-3.8-%PF%

cd ..\..\..\r\c.wip\lief-feedstock

set PY_INTERP_DEBUG=yes
set BLD_DIRNAME=lief-3.8-dbg-%PF%
:: set BLD_DIRNAME=lief
set DST_DIR=%CONDA_PREFIX%\conda-bld\lief-3.8-dbg-%PF%
set CB_CROOT=%CONDA_PREFIX%\conda-bld\%BLD_DIRNAME%
call conda activate
del /s /q %CB_CROOT%
del /s /q %DST_DIR%
mkdir %CB_CROOT%
conda-build --croot %CB_CROOT% -m ..\..\a\conda_build_config-dbg.yaml . --python 3.8 --no-build-id -c rdonnelly --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %CB_CROOT%\build.log
if not "%BLD_DIRNAME%"=="lief" move %CB_CROOT% %DST_DIR%

set PY_INTERP_DEBUG=
set BLD_DIRNAME=lief-3.8-%PF%
:: set BLD_DIRNAME=lief
set DST_DIR=%CONDA_PREFIX%\conda-bld\lief-3.8-%PF%
set CB_CROOT=%CONDA_PREFIX%\conda-bld\%BLD_DIRNAME%
call conda activate
del /s /q %CB_CROOT%
del /s /q %DST_DIR%
mkdir %CB_CROOT%
conda-build --croot %CB_CROOT% -m ..\..\a\conda_build_config.yaml . --python 3.8 --no-build-id -c rdonnelly --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %CB_CROOT%\build.log
if not "%BLD_DIRNAME%"=="lief" move %CB_CROOT% %DST_DIR%

set PY_INTERP_DEBUG=
set BLD_DIRNAME=lief-3.7-%PF%
:: set BLD_DIRNAME=lief
set DST_DIR=%CONDA_PREFIX%\conda-bld\lief-3.7-%PF%
set CB_CROOT=%CONDA_PREFIX%\conda-bld\%BLD_DIRNAME%
call conda activate
del /s /q %CB_CROOT%
del /s /q %DST_DIR%
mkdir %CB_CROOT%
conda-build --croot %CB_CROOT% -m ..\..\a\conda_build_config.yaml . --python 3.7 --no-build-id -c rdonnelly --keep-old-work --dirty %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee %CB_CROOT%\build.log
if not "%BLD_DIRNAME%"=="lief" move %CB_CROOT% %DST_DIR%

cd %OLDCD%
set CONDA_DLL_SEARCH_MODIFICATION_ENABLE=1
set CONDA_DLL_SEARCH_MODIFICATION_DEBUG=1

conda activate C:\opt\conda\conda-bld\lief-3.8-dbg-win-64\lief\_h_env
python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')"

conda activate C:\opt\conda\conda-bld\lief-3.8-win-64\lief\_h_env
python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')"

conda activate C:\opt\conda\conda-bld\lief-3.7-win-64\lief\_h_env_moved_py-lief-0.10.1-py37ha925a31_0_win-64
python -c "from ctypes import *; from sys import *; cdll.LoadLibrary(prefix+'/lib/site-packages/lief.pyd')"
