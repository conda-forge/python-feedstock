setlocal EnableDelayedExpansion
echo on

if "%target_platform%"=="win-64" (
   set HOST_DIR=amd64
)
if "%target_platform%"=="win-32" (
   set HOST_DIR=win32
)
if "%target_platform%"=="win-arm64" (
   set HOST_DIR=arm64
)

for /F "tokens=1,2 delims=." %%i in ("%PKG_VERSION%") do (
  set "VERNODOTS=%%i%%j"
)

if "%PY_INTERP_DEBUG%"=="yes" (
  set _D=_d
) else (
  set _D=
)

if "%PY_FREETHREADING%" == "yes" (
  set "THREAD=t"
) else (
  set "THREAD="
)

:: move python*.dll
for %%x in (python%VERNODOTS%%THREAD%%_D%.dll python3%THREAD%%_D%.dll) do (
  if exist %SRC_DIR%\PCbuild\%HOST_DIR%\%%x (
    copy /Y %SRC_DIR%\PCbuild\%HOST_DIR%\%%x %PREFIX%
  ) else (
    echo "WARNING :: %SRC_DIR%\PCbuild\%HOST_DIR%\%%x does not exist"
  )
)
