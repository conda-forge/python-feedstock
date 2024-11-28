setlocal EnableDelayedExpansion
echo on

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


if "%DEBUG_C%"=="yes" (
  set PGO=
) else (
  set PGO=--pgo
)

if "%PY_FREETHREADING%" == "yes" (
  set "FREETHREADING=--disable-gil"
  set "THREAD=t"
  set "EXE_T=%VER%t"
) else (
  set "FREETHREADING="
  set "THREAD="
  set "EXE_T="
)

:: AP doesn't support PGO atm?
set PGO=

cd PCbuild

:: Twice because:
:: error : importlib_zipimport.h updated. You will need to rebuild pythoncore to see the changes.
call build.bat %PGO% %CONFIG% %FREETHREADING% --experimental-jit-off -m -e -v -p %PLATFORM%
call build.bat %PGO% %CONFIG% %FREETHREADING% --experimental-jit-off -m -e -v -p %PLATFORM%
if errorlevel 1 exit 1
cd ..

:: Populate the root package directory
for %%x in (python%VERNODOTS%%THREAD%%_D%.dll python3%THREAD%%_D%.dll python%EXE_T%%_D%.exe pythonw%EXE_T%%_D%.exe) do (
  if exist %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x (
    copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x %PREFIX%
  ) else (
    echo "WARNING :: %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x does not exist"
  )
)

for %%x in (python%THREAD%%_D%.pdb python%VERNODOTS%%THREAD%%_D%.pdb pythonw%THREAD%%_D%.pdb) do (
  if exist %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x (
    copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x %PREFIX%
  ) else (
    echo "WARNING :: %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x does not exist"
  )
)

@echo on

copy %SRC_DIR%\LICENSE %PREFIX%\LICENSE_PYTHON.txt
if errorlevel 1 exit 1

:: Populate the DLLs directory
mkdir %PREFIX%\DLLs
xcopy /s /y %SRC_DIR%\PCBuild\%BUILD_PATH%\*.pyd %PREFIX%\DLLs\
if errorlevel 1 exit 1

copy /Y %SRC_DIR%\PC\icons\py.ico %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PC\icons\pyc.ico %PREFIX%\DLLs\
if errorlevel 1 exit 1

:: Populate the Tools directory
mkdir %PREFIX%\Tools
xcopy /s /y /i %SRC_DIR%\Tools\i18n %PREFIX%\Tools\i18n
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\scripts %PREFIX%\Tools\scripts
if errorlevel 1 exit 1

del %PREFIX%\Tools\scripts\README
if errorlevel 1 exit 1
del %PREFIX%\Tools\scripts\idle3
if errorlevel 1 exit 1

move /y %PREFIX%\Tools\scripts\pydoc3 %PREFIX%\Tools\scripts\pydoc3.py
if errorlevel 1 exit 1

:: Populate the include directory
xcopy /s /y %SRC_DIR%\Include %PREFIX%\include\
if errorlevel 1 exit 1

:: Copy generated pyconfig.h
copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\pyconfig.h %PREFIX%\include\
if errorlevel 1 exit 1

:: Populate the Scripts directory
if not exist %SCRIPTS% (mkdir %SCRIPTS%)
if errorlevel 1 exit 1

for %%x in (idle pydoc) do (
    copy /Y %SRC_DIR%\Tools\scripts\%%x3 %SCRIPTS%\%%x
    if errorlevel 1 exit 1
)

:: Populate the libs directory
if not exist %PREFIX%\libs mkdir %PREFIX%\libs
dir %SRC_DIR%\PCbuild\%BUILD_PATH%\
if exist %SRC_DIR%\PCbuild\%BUILD_PATH%\python%VERNODOTS%%THREAD%%_D%.lib copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\python%VERNODOTS%%THREAD%%_D%.lib %PREFIX%\libs\
if errorlevel 1 exit 1
if exist %SRC_DIR%\PCbuild\%BUILD_PATH%\python3%THREAD%%_D%.lib copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\python3%THREAD%%_D%.lib %PREFIX%\libs\
if errorlevel 1 exit 1
if exist %SRC_DIR%\PCbuild\%BUILD_PATH%\_tkinter%THREAD%%_D%.lib copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\_tkinter%THREAD%%_D%.lib %PREFIX%\libs\
if errorlevel 1 exit 1


:: Populate the Lib directory
del %PREFIX%\libs\libpython*.a
xcopy /s /y %SRC_DIR%\Lib %PREFIX%\Lib\
if errorlevel 1 exit 1

:: Copy venv[w]launcher scripts to venv\srcipts\nt
:: See https://github.com/python/cpython/blob/b4a316087c32d83e375087fd35fc511bc430ee8b/Lib/venv/__init__.py#L334-L376
if exist %SRC_DIR%\PCbuild\%BUILD_PATH%\venvlauncher%THREAD%%_D%.exe (
  @rem We did copy pythonw.exe until 3.12 but starting with 3.13 we seem to need the latter. Should we omit the first?
  copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\venvlauncher%THREAD%%_D%.exe %PREFIX%\Lib\venv\scripts\nt\python.exe
  copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\venvlauncher%THREAD%%_D%.exe %PREFIX%\Lib\venv\scripts\nt\venvlauncher%THREAD%%_D%.exe
) else (
  echo "WARNING :: %SRC_DIR%\PCbuild\%BUILD_PATH%\venvlauncher%THREAD%%_D%.exe does not exist"
)

if exist %SRC_DIR%\PCbuild\%BUILD_PATH%\venvwlauncher%THREAD%%_D%.exe (
  @rem We did copy pythonw.exe until 3.12 but starting with 3.13 we seem to need the latter. Should we omit the first?
  copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\venvwlauncher%THREAD%%_D%.exe %PREFIX%\Lib\venv\scripts\nt\pythonw.exe
  copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\venvwlauncher%THREAD%%_D%.exe %PREFIX%\Lib\venv\scripts\nt\venvwlauncher%THREAD%%_D%.exe
) else (
  echo "WARNING :: %SRC_DIR%\PCbuild\%BUILD_PATH%\venvwlauncher%THREAD%%_D%.exe does not exist"
)

:: Remove test data to save space.
:: Though keep `support` as some things use that.
mkdir %PREFIX%\Lib\test_keep
if errorlevel 1 exit 1
move %PREFIX%\Lib\test\__init__.py %PREFIX%\Lib\test_keep\
if errorlevel 1 exit 1
move %PREFIX%\Lib\test\support %PREFIX%\Lib\test_keep\
if errorlevel 1 exit 1
rd /s /q %PREFIX%\Lib\test
if errorlevel 1 exit 1
move %PREFIX%\Lib\test_keep %PREFIX%\Lib\test
if errorlevel 1 exit 1

:: We need our Python to be found!
if "%_D%" neq "" copy %PREFIX%\python%_D%.exe %PREFIX%\python.exe
if "%EXE_T%" neq "" copy %PREFIX%\python%EXE_T%.exe %PREFIX%\python.exe

:: bytecode compile the standard library
%PREFIX%\python.exe -Wi %PREFIX%\Lib\compileall.py -f -q -x "bad_coding|badsyntax|py2_" %PREFIX%\Lib
if errorlevel 1 exit 1

:: Ensure `sysconfig`'s data is also compiled
%PREFIX%\python.exe -c "import pprint, sysconfig; pprint(sysconfig.get_config_vars())"
if %errorlevel% neq 1 exit /b 1

:: Ensure that scripts are generated
:: https://github.com/conda-forge/python-feedstock/issues/384
%PREFIX%\python.exe %RECIPE_DIR%\fix_staged_scripts.py
if errorlevel 1 exit 1

:: Some quick tests for common failures
echo "Testing print() does not print: Hello"
%PREFIX%\python.exe -c "print()" 2>&1 | findstr /r /c:"Hello"
if %errorlevel% neq 1 exit /b 1

echo "Testing print('Hello') prints: Hello"
%PREFIX%\python.exe -c "print('Hello')" 2>&1 | findstr /r /c:"Hello"
if %errorlevel% neq 0 exit /b 1

echo "Testing import of os (no DLL needed) does not print: The specified module could not be found"
%PREFIX%\python.exe -v -c "import os" 2>&1
%PREFIX%\python.exe -v -c "import os" 2>&1 | findstr /r /c:"The specified module could not be found"
if %errorlevel% neq 1 exit /b 1

echo "Testing import of _sqlite3 (DLL located via PATH needed) does not print: The specified module could not be found"
%PREFIX%\python.exe -v -c "import _sqlite3" 2>&1
%PREFIX%\python.exe -v -c "import _sqlite3" 2>&1 | findstr /r /c:"The specified module could not be found"
if %errorlevel% neq 1 exit /b 1
