@echo on

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
if not exist %PREFIX%\etc\conda\activate.d mkdir %PREFIX%\etc\conda\activate.d
copy %RECIPE_DIR%\scripts\activate.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_activate.bat
if errorlevel 1 exit 1
:: We also copy .sh scripts to be able to use them with POSIX CLI on Windows.
copy %RECIPE_DIR%\scripts\activate.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_activate.sh
if errorlevel 1 exit 1

if not exist %PREFIX%\etc\conda\deactivate.d mkdir %PREFIX%\etc\conda\deactivate.d
copy %RECIPE_DIR%\scripts\deactivate.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_deactivate.bat
if errorlevel 1 exit 1
copy %RECIPE_DIR%\scripts\deactivate.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_deactivate.sh
if errorlevel 1 exit 1
