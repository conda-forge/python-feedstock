set PF=win-32
set PF=win-64
set OLDCD=%~dp0

call conda activate

:: set PY_INTERP_DEBUG=yes
:: del /s /q %CONDA_PREFIX%\conda-bld\python
:: del /s /q %CONDA_PREFIX%\conda-bld\python-3.8-dbg-%PF%
:: mkdir %CONDA_PREFIX%\conda-bld\python
:: conda-build -m ..\..\a\conda_build_config-dbg.yaml . --python 3.7 --no-build-id -c rdonnelly --keep-old-work --dirty 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\conda-bld\python\build.log
:: move %CONDA_PREFIX%\conda-bld\python %CONDA_PREFIX%\conda-bld\python-3.8-dbg-%PF%
:: 
:: set PY_INTERP_DEBUG=
:: del /s /q %CONDA_PREFIX%\conda-bld\python
:: del /s /q %CONDA_PREFIX%\conda-bld\python-3.8-%PF%
:: mkdir %CONDA_PREFIX%\conda-bld\python
:: conda-build -m ..\..\a\conda_build_config.yaml . --python 3.7 --no-build-id -c rdonnelly --keep-old-work --dirty 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\conda-bld\python\build.log
:: move %CONDA_PREFIX%\conda-bld\python %CONDA_PREFIX%\conda-bld\python-3.8-%PF%

cd ..\..\..\r\c.wip\lief-feedstock

set PY_INTERP_DEBUG=yes
call conda activate
del /s /q %CONDA_PREFIX%\conda-bld\lief
del /s /q %CONDA_PREFIX%\conda-bld\lief-3.8-dbg-%PF%
mkdir %CONDA_PREFIX%\conda-bld\lief
conda-build -m ..\..\a\conda_build_config-dbg.yaml . --python 3.8 --no-build-id -c rdonnelly --keep-old-work --dirty 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\conda-bld\lief\build.log
move %CONDA_PREFIX%\conda-bld\lief %CONDA_PREFIX%\conda-bld\lief-3.8-dbg-%PF%

set PY_INTERP_DEBUG=
del /s /q %CONDA_PREFIX%\conda-bld\lief
del /s /q %CONDA_PREFIX%\conda-bld\lief-3.8-%PF%
mkdir %CONDA_PREFIX%\conda-bld\lief
conda-build -m ..\..\a\conda_build_config.yaml . --python 3.8 --no-build-id -c rdonnelly --keep-old-work --dirty 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\conda-bld\lief\build.log
move %CONDA_PREFIX%\conda-bld\lief %CONDA_PREFIX%\conda-bld\lief-3.8-%PF%

set PY_INTERP_DEBUG=
del /s /q %CONDA_PREFIX%\conda-bld\lief
del /s /q %CONDA_PREFIX%\conda-bld\lief-3.7-%PF%
mkdir %CONDA_PREFIX%\conda-bld\lief
conda-build -m ..\..\a\conda_build_config.yaml . --python 3.7 --no-build-id -c rdonnelly --keep-old-work --dirty 2>&1 | C:\msys32\usr\bin\tee %CONDA_PREFIX%\conda-bld\lief\build.log
move %CONDA_PREFIX%\conda-bld\lief %CONDA_PREFIX%\conda-bld\lief-3.7-%PF%

cd %OLDCD%
