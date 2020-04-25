@echo on

REM brand Python with conda-forge startup message
REM %SYS_PYTHON% %RECIPE_DIR%\brand_python.py
REM if errorlevel 1 exit 1

REM Compile python, extensions and external libraries
if "%ARCH%"=="64" (
   set PLATFORM=x64
   set VC_PATH=x64
   set BUILD_PATH=amd64
) else (
   set PLATFORM=Win32
   set VC_PATH=x86
   set BUILD_PATH=win32
)

cd PCbuild
call build.bat -m -e -v -p %PLATFORM%
if errorlevel 1 exit 1
cd ..

REM Populate the root package directory
for %%x in (python36.dll python3.dll python.exe pythonw.exe) do (
    copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x %PREFIX%
    if errorlevel 1 exit 1
)

for %%x in (python.pdb python36.pdb pythonw.pdb) do (
    copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\%%x %PREFIX%
    if errorlevel 1 exit 1
)

copy %SRC_DIR%\LICENSE %PREFIX%\LICENSE_PYTHON.txt
if errorlevel 1 exit 1


REM Populate the DLLs directory
mkdir %PREFIX%\DLLs
xcopy /s /y %SRC_DIR%\PCBuild\%BUILD_PATH%\*.pyd %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\sqlite3.dll %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\tcl86t.dll %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\tk86t.dll %PREFIX%\DLLs\
if errorlevel 1 exit 1

copy /Y %SRC_DIR%\PC\icons\py.ico %PREFIX%\DLLs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PC\icons\pyc.ico %PREFIX%\DLLs\
if errorlevel 1 exit 1


REM Populate the Tools directory
mkdir %PREFIX%\Tools
xcopy /s /y /i %SRC_DIR%\Tools\demo %PREFIX%\Tools\demo
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\i18n %PREFIX%\Tools\i18n
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\parser %PREFIX%\Tools\parser
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\pynche %PREFIX%\Tools\pynche
if errorlevel 1 exit 1
xcopy /s /y /i %SRC_DIR%\Tools\scripts %PREFIX%\Tools\scripts
if errorlevel 1 exit 1

del %PREFIX%\Tools\demo\README
if errorlevel 1 exit 1
del %PREFIX%\Tools\pynche\README
if errorlevel 1 exit 1
del %PREFIX%\Tools\pynche\pynche
if errorlevel 1 exit 1
del %PREFIX%\Tools\scripts\README
if errorlevel 1 exit 1
del %PREFIX%\Tools\scripts\dutree.doc
if errorlevel 1 exit 1
del %PREFIX%\Tools\scripts\idle3
if errorlevel 1 exit 1

move /y %PREFIX%\Tools\scripts\2to3 %PREFIX%\Tools\scripts\2to3.py
if errorlevel 1 exit 1
move /y %PREFIX%\Tools\scripts\pydoc3 %PREFIX%\Tools\scripts\pydoc3.py
if errorlevel 1 exit 1
move /y %PREFIX%\Tools\scripts\pyvenv %PREFIX%\Tools\scripts\pyvenv.py
if errorlevel 1 exit 1

:: REM Copy OpenSLL DLLs (not needed as these are
:: REM statically inked to _ssl and _hashlib now)
:: copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\libcrypto*.dll %PREFIX%\DLLs\
:: if errorlevel 1 exit 1
:: copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\libssl*.dll %PREFIX%\DLLs\
:: if errorlevel 1 exit 1

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
    copy /Y %SRC_DIR%\Tools\scripts\%%x3 %SCRIPTS%\%%x
    if errorlevel 1 exit 1
)

copy /Y %SRC_DIR%\Tools\scripts\2to3 %SCRIPTS%
if errorlevel 1 exit 1

REM Populate the libs directory
mkdir %PREFIX%\libs
copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\python36.lib %PREFIX%\libs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\python3.lib %PREFIX%\libs\
if errorlevel 1 exit 1
copy /Y %SRC_DIR%\PCbuild\%BUILD_PATH%\_tkinter.lib %PREFIX%\libs\
if errorlevel 1 exit 1


REM Populate the Lib directory
del %PREFIX%\libs\libpython*.a
xcopy /s /y %SRC_DIR%\Lib %PREFIX%\Lib\
if errorlevel 1 exit 1

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

REM bytecode compile the standard library

rd /s /q %PREFIX%\Lib\lib2to3\tests\
if errorlevel 1 exit 1

%PREFIX%\python.exe -Wi %PREFIX%\Lib\compileall.py -f -q -x "bad_coding|badsyntax|py2_" %PREFIX%\Lib
if errorlevel 1 exit 1


REM Pickle lib2to3 Grammar
%PREFIX%\python.exe -m lib2to3 --help
