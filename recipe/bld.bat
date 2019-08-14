echo on
REM brand Python with conda-forge startup message
REM %SYS_PYTHON% %RECIPE_DIR%\brand_python.py
REM if errorlevel 1 exit 1

:: See https://github.com/conda-forge/staged-recipes/pull/194#issuecomment-203577297
:: Nasty workaround. Need to have a more current msbuild in PATH. The chosen one
:: is C:\Windows\Microsoft.NET\Framework64\v3.5\MSBuild.exe, which is incompatible:
:: error MSB4066: The attribute "Label" in element <PropertyGroup> is unrecognized.
:: The msbuild.exe from the Win7 SDK (.net 4.0), is known to work.
if %VS_MAJOR% == 9 (
    COPY C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe .\
    set "PATH=%CD%;%PATH%"
)

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

set "SQLITE3_DIR=%LIBRARY_PREFIX%"

cd PCbuild
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
:: Though keep `test_support` as some things use that.
mkdir %PREFIX%\Lib\test_keep
if errorlevel 1 exit 1
move %PREFIX%\Lib\test\__init__.py %PREFIX%\Lib\test_keep\
if errorlevel 1 exit 1
move %PREFIX%\Lib\test\test_support.py %PREFIX%\Lib\test_keep\
if errorlevel 1 exit 1
rd /s /q %PREFIX%\Lib\test
if errorlevel 1 exit 1
move %PREFIX%\Lib\test_keep %PREFIX%\Lib\test
if errorlevel 1 exit 1

REM bytecode compile the standard library

%PREFIX%\python.exe -Wi %PREFIX%\Lib\compileall.py -f -q -x "bad_coding|badsyntax|py3_|ttk" %PREFIX%\Lib
if errorlevel 1 exit 1


REM Pickle lib2to3 Grammar
%PREFIX%\python.exe -m lib2to3 --help
