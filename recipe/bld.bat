REM brand Python with conda-forge startup message
python %RECIPE_DIR%\brand_python.py
if errorlevel 1 exit 1


REM Compile python, extensions and external libraries
if "%ARCH%"=="64" (
   set PLATFORM=x64
   set VC_PATH=x64
   set PCB=%SRC_DIR%\PCbuild\amd64
) else (
   set PLATFORM=Win32
   set VC_PATH=x86
   set PCB=%SRC_DIR%\PCbuild
)

cd PCbuild
dir
call build.bat -e -p %PLATFORM%
if errorlevel 1 exit 1
cd ..


REM Populate the root package directory
for %%x in (python27.dll python.exe pythonw.exe w9xpopen.exe) do (
    copy /Y %PCB%\%%x %PREFIX%
    if errorlevel 1 exit 1
)

for %%x in (python.pdb python27.pdb pythonw.pdb) do (
    copy /Y %PCB%\%%x %PREFIX%
    if errorlevel 1 exit 1
)


REM Populate the DLLs directory
mkdir %PREFIX%\DLLs
xcopy /s /y %PCB%\*.pyd %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %PCB%\sqlite3.dll %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %PCB%\tcl85.dll %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %PCB%\tk85.dll %PREFIX%\DLLs\
if errorlevel 1 exit 1

if "%ARCH%"=="64" (
   copy /Y %SRC_DIR%\externals\tcltk64\bin\tclpip85.dll %PREFIX%\DLLs\
   if errorlevel 1 exit 1
) else (
   copy /Y %SRC_DIR%\externals\tcltk\bin\tclpip85.dll %PREFIX%\DLLs\
   if errorlevel 1 exit 1
)

copy /Y %SRC_DIR%\PC\py.ico %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PC\pyc.ico %PREFIX%\DLLs\
if errorlevel 1 exit 1

xcopy /s /y %PCB%\*.pdb %PREFIX%\DLLs\
if errorlevel 1 exit 1
for %%x in (python.pdb python27.pdb pythonw.pdb w9xpopen.pdb) do (
    del %PREFIX%\DLLs\%%x
    if errorlevel 1 exit 1
)


REM Populate the Tools directory
mkdir %PREFIX%\Tools
xcopy /s /y /i %SRC_DIR%\Tools\scripts %PREFIX%\Tools\Scripts
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\i18n %PREFIX%\Tools\i18n
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\pynche %PREFIX%\Tools\pynche
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\versioncheck %PREFIX%\Tools\versioncheck
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\webchecker %PREFIX%\Tools\webchecker
if errorlevel 1 exit 1

del %PREFIX%\Tools\Scripts\idle
if errorlevel 1 exit 1
del %PREFIX%\Tools\Scripts\pydoc
if errorlevel 1 exit 1

move /y %PREFIX%\Tools\Scripts\2to3 %PREFIX%\Tools\Scripts\2to3.py
if errorlevel 1 exit 1


REM Populate the tcl directory
if "%ARCH%"=="64" (
   xcopy /s /y /i %SRC_DIR%\externals\tcltk64\lib %PREFIX%\tcl
   if errorlevel 1 exit 1
) else (
   xcopy /s /y /i %SRC_DIR%\externals\tcltk\lib %PREFIX%\tcl
   if errorlevel 1 exit 1
)


REM Populate the include directory
xcopy /s /y %SRC_DIR%\Include %PREFIX%\include\
if errorlevel 1 exit 1

copy /Y %SRC_DIR%\PC\pyconfig.h %PREFIX%\include\
if errorlevel 1 exit 1


REM Populate the Scripts directory
IF NOT exist %SCRIPTS% (mkdir %SCRIPTS%)
if errorlevel 1 exit 1

for %%x in (idle pydoc) do (
    copy /Y %SRC_DIR%\Tools\scripts\%%x %SCRIPTS%\%%x
    if errorlevel 1 exit 1
)

copy /Y %SRC_DIR%\Tools\scripts\2to3 %SCRIPTS%
if errorlevel 1 exit 1


REM Populate the libs directory
mkdir %PREFIX%\libs
xcopy /s /y %PCB%\*.lib %PREFIX%\libs\
if errorlevel 1 exit 1
del %PREFIX%\libs\libeay.lib %PREFIX%\libs\sqlite3.lib %PREFIX%\libs\ssleay.lib


::REM Populate the Lib directory
del %PREFIX%\libs\libpython*.a
xcopy /s /y %SRC_DIR%\Lib %PREFIX%\Lib\
if errorlevel 1 exit 1

:: Remove test data to save space.
rd /s /q %PREFIX%\Lib\test
if errorlevel 1 exit 1

:: Remove ensurepip stubs.
rd /s /q %PREFIX%\Lib\ensurepip
if errorlevel 1 exit 1


REM bytecode compile the standard library

%PYTHON% -Wi %STDLIB_DIR%\compileall.py -f -q -x "bad_coding|badsyntax|py3_" %STDLIB_DIR%
if errorlevel 1 exit 1


REM Pickle lib2to3 Grammar
%PYTHON% -m lib2to3 --help
