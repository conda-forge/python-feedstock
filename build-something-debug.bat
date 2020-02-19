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

if %_BS_THREE_EIGHT%==yes (
  if %_BS_DEBUG_ME%==yes (
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%_dbg.tar.bz2 /b /a-d >nul 2>&1 (
      set _BS_PY_INTERP_DEBUG=yes
      set _BS_BLD_DIRNAME=%_BS_NAME%-dbg-3.8.1-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
      del /s /q !DST_DIR!
      mkdir !DST_DIR!
      conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.8.1-%PF% -m %DBG_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
    )
  )

  if %_BS_RELEASE_ME%==yes (
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%.tar.bz2 /b /a-d >nul 2>&1 (
      set _BS_PY_INTERP_DEBUG=yes
      set _BS_BLD_DIRNAME=%_BS_NAME%-3.8.1-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
      del /s /q !DST_DIR!
      mkdir !DST_DIR!
      conda-build --croot %CB_CROOT% --build-id-pat {n}-3.8.1-%PF% -m %DBG_CFG% . --python 3.8 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
    )
  )
)

if %_BS_THREE_SEVEN%==yes (
  if %_BS_DEBUG_ME%==yes (
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%_dbg.tar.bz2 /b /a-d >nul 2>&1 (
      set _BS_PY_INTERP_DEBUG=yes
      set _BS_BLD_DIRNAME=%_BS_NAME%-dbg-3.7.6-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
      del /s /q !DST_DIR!
      mkdir !DST_DIR!
      conda-build --croot %CB_CROOT% --build-id-pat {n}-dbg-3.7.6-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
    )
  )

  if %_BS_RELEASE_ME%==yes (
    if "%_BS_SKIP_WILDCARD%"=="" or not dir %_BS_CB_CROOT%\%_BS_SKIP_WILDCARD_PREFIX%.tar.bz2 /b /a-d >nul 2>&1 (
      set _BS_PY_INTERP_DEBUG=yes
      set _BS_BLD_DIRNAME=%_BS_NAME%-3.7.6-%_BS_CB_CONDA_SUBDIR%
      set _BS_DST_DIR=%CB_CROOT%\!BLD_DIRNAME!
      del /s /q !DST_DIR!
      mkdir !DST_DIR!
      conda-build --croot %CB_CROOT% --build-id-pat {n}-3.7.6-%PF% -m %DBG_CFG% . --python 3.7 %CHANNELS% %CB_KEEP% %CB_DEBUG% 2>&1 | C:\msys32\usr\bin\tee !DST_DIR!\build.log
    )
  )
)

popd
:skip_it
