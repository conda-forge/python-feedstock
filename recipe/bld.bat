setlocal EnableDelayedExpansion
echo on

:: Compile python, extensions and external libraries
if "%target_platform%"=="win-64" (
   set HOST_PLATFORM=x64
   set HOST_DIR=amd64
)
if "%target_platform%"=="win-32" (
   set HOST_PLATFORM=Win32
   set HOST_DIR=win32
)
if "%target_platform%"=="win-arm64" (
   set HOST_PLATFORM=ARM64
   set HOST_DIR=arm64
)

if "%build_platform%"=="win-64" (
   set BUILD_PLATFORM=x64
   set BUILD_DIR=amd64
)
if "%build_platform%"=="win-32" (
   set BUILD_PLATFORM=Win32
   set BUILD_DIR=win32
)
if "%build_platform%"=="win-arm64" (
   set BUILD_PLATFORM=ARM64
   set BUILD_DIR=arm64
)

for /F "tokens=1,2 delims=." %%i in ("%PKG_VERSION%") do (
  set "VERNODOTS=%%i%%j"
)

for /F "tokens=1,2 delims=." %%i in ("%PKG_VERSION%") do (
  set "VER=%%i.%%j"
)

::  Make sure the "python" value in conda_build_config.yaml is up to date.
for /F "tokens=1,2 delims=." %%i in ("%PKG_VERSION%") do (
  if NOT "%PY_VER%"=="%%i.%%j" exit 1
)

for /f "usebackq delims=" %%i in (`conda list -p %PREFIX% sqlite --no-show-channel-urls --json ^| findstr "version"`) do set SQLITE3_VERSION_LINE=%%i
for /f "tokens=2 delims==/ " %%i IN ('echo %SQLITE3_VERSION_LINE%') do (set SQLITE3_VERSION=%%~i)
echo SQLITE3_VERSION detected as %SQLITE3_VERSION%

if "%PY_INTERP_DEBUG%"=="yes" (
  set CONFIG=-d
  set _D=_d
) else (
  set CONFIG=
  set _D=
)

set PGO=--pgo
if "%DEBUG_C%"=="yes" (
  set PGO=
)
if "%CONDA_BUILD_CROSS_COMPILATION%" == "1" (
  set PGO=
)

if "%PY_FREETHREADING%" == "yes" (
  set "FREETHREADING=--disable-gil"
  set "THREAD=t"
  set "EXE_T=%VER%t"
) else (
  set "FREETHREADING=--experimental-jit-off"
  set "THREAD="
  set "EXE_T="
)

:: TODO: remove once tk 9 is available on main
:: Pin Tcl/Tk from the `tk` variant in conda_build_config.yaml (single source of
:: truth, shared with build_base.sh). Upstream 3.15 tcltk.props defaults
:: TclVersion to 9.0.3.0, but pkgs/main only ships tk 8.6; MSBuild derives the
:: lib names (tcl86t.lib/tk86t.lib) from the major.minor of these props.
set TCLTK_MSBUILD_PROPS="/p:TclVersion=%tk%" "/p:TkVersion=%tk%"

cd PCbuild

setlocal EnableDelayedExpansion
if "%CONDA_BUILD_CROSS_COMPILATION%" == "1" (
  REM build for the build platform. LIBRARY_PREFIX is used by the patches
  REM No PGO. No externals, i.e. remove building extension modules
  REM we don't need.
  set LIBRARY_PREFIX=%BUILD_PREFIX%\\Library
  call build.bat %CONFIG% %FREETHREADING% -m -E -v -p %BUILD_PLATFORM% %TCLTK_MSBUILD_PROPS%
  if errorlevel 1 exit 1
)
endlocal
:: Twice because:
:: error : importlib_zipimport.h updated. You will need to rebuild pythoncore to see the changes.
call build.bat %PGO% %CONFIG% %FREETHREADING% -m -e -v -p %HOST_PLATFORM% %TCLTK_MSBUILD_PROPS%
call build.bat %PGO% %CONFIG% %FREETHREADING% -m -e -v -p %HOST_PLATFORM% %TCLTK_MSBUILD_PROPS%
if errorlevel 1 exit 1
cd ..
