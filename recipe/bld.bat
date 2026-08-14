setlocal EnableDelayedExpansion
echo on

:: brand Python with conda-forge startup message
%SYS_PYTHON% %RECIPE_DIR%\brand_python.py
if errorlevel 1 exit 1

:: Compile python, extensions and external libraries
if "%ARCH%"=="64" (
   set PLATFORM=x64
   set VC_PATH=x64
   set BUILD_PATH=amd64
) else (
   set PLATFORM=Win32
   set VC_PATH=x86
   set BUILD_PATH=win32
)

for /F "tokens=1,2 delims=." %%i in ("%PKG_VERSION%") do (
  set "VERNODOTS=%%i%%j"
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


if "%DEBUG_C%"=="yes" (
  set PGO=
) else (
  set PGO=--pgo
)

:: AP doesn't support PGO atm?
set PGO=

cd PCbuild

:: Twice because:
:: error : importlib_zipimport.h updated. You will need to rebuild pythoncore to see the changes.
call build.bat %PGO% %CONFIG% -m -e -v -p %PLATFORM%
call build.bat %PGO% %CONFIG% -m -e -v -p %PLATFORM%
if errorlevel 1 exit 1
cd ..
