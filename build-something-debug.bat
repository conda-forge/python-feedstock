setlocal EnableDelayedExpansion

set _BS_CB_CROOT=%1
set _BS_CB_CONDA_SUBDIR=%2
set _BS_NAME=%3
set _BS_RECIPE_DIR=%4
set _BS_THREE_SEVEN=%5
set _BS_THREE_EIGHT=%6
set _BS_DEBUG_ME=%7
set _BS_RELEASE_ME=%8
set _BS_SKIP_WILDCARD_PREFIX=%9

pushd %_BS_RECIPE_DIR%

echo _BS_CB_CROOT=%_BS_CB_CROOT%
echo _BS_CB_CONDA_SUBDIR=%2
echo _BS_NAME=%_BS_NAME%
echo _BS_RECIPE_DIR=%_BS_RECIPE_DIR%
echo _BS_THREE_SEVEN=%_BS_THREE_SEVEN%
echo _BS_THREE_EIGHT=%_BS_THREE_EIGHT%
echo _BS_DEBUG_ME=%_BS_DEBUG_ME%
echo _BS_RELEASE_ME=%_BS_RELEASE_ME%
echo _BS_SKIP_WILDCARD_PREFIX=%_BS_SKIP_WILDCARD_PREFIX%

if %_BS_THREE_EIGHT%==no goto _bs_skip_38
  if %_BS_DEBUG_ME%==no goto _bs_skip_38_del
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%_dbg.tar.bz2 /b /a-d >nul 2>&1 (
      set PY_INTERP_DEBUG=yes
      set _BS_BLD_DIRNAME=%_BS_NAME%-dbg-3.8.1-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%_BS_CB_CROOT%\!_BS_BLD_DIRNAME!
      del /s /q !_BS_DST_DIR!
      mkdir !_BS_DST_DIR!
      echo conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-dbg-3.8.1-%PF% -m %DBG_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !_BS_DST_DIR!\build.log
      conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-dbg-3.8.1-%PF% -m %DBG_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !_BS_DST_DIR!\build.log
    )
:_bs_skip_38_del

  if %_BS_RELEASE_ME%==no goto _bs_skip_38_rel
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%.tar.bz2 /b /a-d >nul 2>&1 (
      set PY_INTERP_DEBUG=no
      set _BS_BLD_DIRNAME=%_BS_NAME%-3.8.1-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%_BS_CB_CROOT%\!_BS_BLD_DIRNAME!
      del /s /q !_BS_DST_DIR!
      mkdir !_BS_DST_DIR!
      echo conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-3.8.1-%PF% -m %REL_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !_BS_DST_DIR!\build.log
      conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-3.8.1-%PF% -m %REL_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !_BS_DST_DIR!\build.log
    )
:_bs_skip_38_rel
:_bs_skip_38

if %_BS_THREE_SEVEN%==no goto _bs_skip_37
  if %_BS_DEBUG_ME%==no goto _bs_skip_37_deb
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%_dbg.tar.bz2 /b /a-d >nul 2>&1 (
      set PY_INTERP_DEBUG=yes
      set _BS_BLD_DIRNAME=%_BS_NAME%-dbg-3.7.6-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%_BS_CB_CROOT%\!_BS_BLD_DIRNAME!
      del /s /q !_BS_DST_DIR!
      mkdir !_BS_DST_DIR!
      echo conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-dbg-3.7.6-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !_BS_DST_DIR!\build.log
      conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-dbg-3.7.6-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !_BS_DST_DIR!\build.log
    )
:_bs_skip_37_deb

  if %_BS_RELEASE_ME%==no goto _bs_skip_37_rel
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%.tar.bz2 /b /a-d >nul 2>&1 (
      set PY_INTERP_DEBUG=no
      set _BS_BLD_DIRNAME=%_BS_NAME%-3.7.6-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%_BS_CB_CROOT%\!_BS_BLD_DIRNAME!
      del /s /q !_BS_DST_DIR!
      mkdir !_BS_DST_DIR!
      echo conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-3.7.6-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% | C:\msys32\usr\bin\tee !_BS_DST_DIR!\build.log
      conda-build --croot %_BS_CB_CROOT% --build-id-pat {n}-3.7.6-%PF% -m %REL_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee -a !_BS_DST_DIR!\build.log
    )
:_bs_skip_37_rel
:_bs_skip_37

popd
