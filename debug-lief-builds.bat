:: rmdir /s /q lief-bug
mkdir lief-bug
cd lief-bug

:: If you set this to yes things get cloned apppropriately. It is easier.
set FROM_GIT=yes

:: .. then this does not matter, otherwise it is expected you have a file tree layout with the following:
:: git@github.com:AnacondaRecipes/python-feedstock r/a/python-feedstock -b master
:: git@github.com:AnacondaRecipes/python-feedstock r/a/python-3.7-feedstock -b master-3.7
:: git@github.com:AnacondaRecipes/lief-feedstock r/c.wip/lief-feedstock -b 0.10.1-fixes
set COPTSL=/c/opt/Shared.local
set COPTSLD=C:\opt\Shared.local
:: set COPTSL=/c/opt
:: set COPTSLD=C:\opt

call conda activate
mkdir src
pushd src
if %FROM_GIT%==yes (
  git clone git@github.com:mingwandroid/conda-build conda-build -b LIEF-fixes-2
) else (
  C:\msys64\usr\bin\cp -rf %COPTSL%/asrc/conda-build conda-build
)
pushd conda-build
:: pushd %COPTSLD%\asrc\conda-build
python setup.py develop
popd
popd
mkdir r
pushd r
mkdir a
pushd a
if not exist python-3.7-feedstock (
  if %FROM_GIT%==yes (
    git clone git@github.com:AnacondaRecipes/python-feedstock python-3.7-feedstock -b master-3.7
  ) else (
    C:\msys64\usr\bin\cp -rf %COPTSL%/r/a/python-3.7-feedstock python-3.7-feedstock
  )
)
if not exist python-feedstock (
  if %FROM_GIT%==yes (
    git clone git@github.com:AnacondaRecipes/python-feedstock python-feedstock -b master
  ) else (
    C:\msys64\usr\bin\cp -rf %COPTSL%/r/a/python-feedstock python-feedstock
  )
)
if not exist python-levenshtein-feedstock (
  if %FROM_GIT%==yes (
    git clone git@github.com:AnacondaRecipes/python-levenshtein-feedstock python-levenshtein-feedstock -b master
  ) else (
    C:\msys64\usr\bin\cp -rf %COPTSL%/r/a/python-levenshtein-feedstock python-levenshtein-feedstock
  )  
)
del /s /q conda_build_config*.yaml
C:\msys64\usr\bin\wget https://raw.githubusercontent.com/AnacondaRecipes/aggregate/master/conda_build_config-dbg.yaml
C:\msys64\usr\bin\wget https://raw.githubusercontent.com/AnacondaRecipes/aggregate/master/conda_build_config-dbg_c-dbg_py.yaml
C:\msys64\usr\bin\wget https://raw.githubusercontent.com/AnacondaRecipes/aggregate/master/conda_build_config-win64.yaml
popd
mkdir c.wip
pushd c.wip
if not exist lief-feedstock (
  if %FROM_GIT%==yes (
    git clone git@github.com:AnacondaRecipes/lief-feedstock lief-feedstock -b 0.10.1-fixes
  ) else (
    C:\msys64\usr\bin\cp -rf %COPTSL%/r/c.wip/lief-feedstock lief-feedstock
  )
)
popd
popd

call r\a\python-feedstock\build-locally-debug.bat
