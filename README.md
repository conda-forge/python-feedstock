About python-feedstock
======================

Feedstock license: [BSD-3-Clause](https://github.com/conda-forge/python-feedstock/blob/main/LICENSE.txt)

Home: https://www.python.org/

Package license: Python-2.0

Summary: General purpose programming language

Development: https://docs.python.org/devguide/

Documentation: https://www.python.org/doc/versions/

Python is a widely used high-level, general-purpose, interpreted, dynamic
programming language. Its design philosophy emphasizes code
readability, and its syntax allows programmers to express concepts in
fewer lines of code than would be possible in languages such as C++ or
Java. The language provides constructs intended to enable clear programs
on both a small and large scale.

We provide some meta packages for convenience.
To get a CPython flavour, use:

    conda install cpython

To get the freethreading build (i.e. without the Global Interpreter Lock - GIL):

    conda install python-freethreading

To get the default build (i.e. with the GIL):

    conda install python-gil

To enable the use of the experimental JIT compiler in CPython:

    conda install python-jit

or set the environment variable PYTHON_JIT=1. Note that the JIT support
is available for x86_64 builds only.


Current build status
====================


<table>
    
  <tr>
    <td>Azure</td>
    <td>
      <details>
        <summary>
          <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
            <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main">
          </a>
        </summary>
        <table>
          <thead><tr><th>Variant</th><th>Status</th></tr></thead>
          <tbody><tr>
              <td>linux_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_aarch64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_aarch64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_aarch64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_aarch64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_aarch64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_aarch64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_aarch64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_aarch64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_ppc64le_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_ppc64le_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_ppc64le_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_ppc64le_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_ppc64le_build_typereleasechannel_targetsconda-forge_mainfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_ppc64le_build_typereleasechannel_targetsconda-forge_mainfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_ppc64le_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_ppc64le_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_arm64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_arm64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_arm64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_arm64_build_typedebugchannel_targetsconda-forge_python_debugfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_arm64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_arm64_build_typereleasechannel_targetsconda-forge_mainfreethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>osx_arm64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=osx&configuration=osx%20osx_arm64_build_typereleasechannel_targetsconda-forge_mainfreethreadingyes" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>win_64_freethreadingno</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=win&configuration=win%20win_64_freethreadingno" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>win_64_freethreadingyes</td>
              <td>
                <a href="https://dev.azure.com/conda-forge/feedstock-builds/_build/latest?definitionId=4155&branchName=main">
                  <img src="https://dev.azure.com/conda-forge/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=win&configuration=win%20win_64_freethreadingyes" alt="variant">
                </a>
              </td>
            </tr>
          </tbody>
        </table>
      </details>
    </td>
  </tr>
</table>

Current release info
====================

| Name | Downloads | Version | Platforms |
| --- | --- | --- | --- |
| [![Conda Recipe](https://img.shields.io/badge/recipe-cpython-green.svg)](https://anaconda.org/conda-forge/cpython) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/cpython.svg)](https://anaconda.org/conda-forge/cpython) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/cpython.svg)](https://anaconda.org/conda-forge/cpython) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/cpython.svg)](https://anaconda.org/conda-forge/cpython) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-libpython--static-green.svg)](https://anaconda.org/conda-forge/libpython-static) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/libpython-static.svg)](https://anaconda.org/conda-forge/libpython-static) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/libpython-static.svg)](https://anaconda.org/conda-forge/libpython-static) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/libpython-static.svg)](https://anaconda.org/conda-forge/libpython-static) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-python-green.svg)](https://anaconda.org/conda-forge/python) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/python.svg)](https://anaconda.org/conda-forge/python) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/python.svg)](https://anaconda.org/conda-forge/python) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/python.svg)](https://anaconda.org/conda-forge/python) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-python--freethreading-green.svg)](https://anaconda.org/conda-forge/python-freethreading) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/python-freethreading.svg)](https://anaconda.org/conda-forge/python-freethreading) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/python-freethreading.svg)](https://anaconda.org/conda-forge/python-freethreading) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/python-freethreading.svg)](https://anaconda.org/conda-forge/python-freethreading) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-python--gil-green.svg)](https://anaconda.org/conda-forge/python-gil) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/python-gil.svg)](https://anaconda.org/conda-forge/python-gil) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/python-gil.svg)](https://anaconda.org/conda-forge/python-gil) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/python-gil.svg)](https://anaconda.org/conda-forge/python-gil) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-python--jit-green.svg)](https://anaconda.org/conda-forge/python-jit) | [![Conda Downloads](https://img.shields.io/conda/dn/conda-forge/python-jit.svg)](https://anaconda.org/conda-forge/python-jit) | [![Conda Version](https://img.shields.io/conda/vn/conda-forge/python-jit.svg)](https://anaconda.org/conda-forge/python-jit) | [![Conda Platforms](https://img.shields.io/conda/pn/conda-forge/python-jit.svg)](https://anaconda.org/conda-forge/python-jit) |

Installing python
=================

Installing `python` from the `conda-forge/label/python_debug` channel can be achieved by adding `conda-forge/label/python_debug` to your channels with:

```
conda config --add channels conda-forge/label/python_debug
conda config --set channel_priority strict
```

Once the `conda-forge/label/python_debug` channel has been enabled, `cpython, libpython-static, python, python-freethreading, python-gil, python-jit` can be installed with `conda`:

```
conda install cpython libpython-static python python-freethreading python-gil python-jit
```

or with `mamba`:

```
mamba install cpython libpython-static python python-freethreading python-gil python-jit
```

It is possible to list all of the versions of `cpython` available on your platform with `conda`:

```
conda search cpython --channel conda-forge/label/python_debug
```

or with `mamba`:

```
mamba search cpython --channel conda-forge/label/python_debug
```

Alternatively, `mamba repoquery` may provide more information:

```
# Search all versions available on your platform:
mamba repoquery search cpython --channel conda-forge/label/python_debug

# List packages depending on `cpython`:
mamba repoquery whoneeds cpython --channel conda-forge/label/python_debug

# List dependencies of `cpython`:
mamba repoquery depends cpython --channel conda-forge/label/python_debug
```


About conda-forge
=================

[![Powered by
NumFOCUS](https://img.shields.io/badge/powered%20by-NumFOCUS-orange.svg?style=flat&colorA=E1523D&colorB=007D8A)](https://numfocus.org)

conda-forge is a community-led conda channel of installable packages.
In order to provide high-quality builds, the process has been automated into the
conda-forge GitHub organization. The conda-forge organization contains one repository
for each of the installable packages. Such a repository is known as a *feedstock*.

A feedstock is made up of a conda recipe (the instructions on what and how to build
the package) and the necessary configurations for automatic building using freely
available continuous integration services. Thanks to the awesome service provided by
[Azure](https://azure.microsoft.com/en-us/services/devops/), [GitHub](https://github.com/),
[CircleCI](https://circleci.com/), [AppVeyor](https://www.appveyor.com/),
[Drone](https://cloud.drone.io/welcome), and [TravisCI](https://travis-ci.com/)
it is possible to build and upload installable packages to the
[conda-forge](https://anaconda.org/conda-forge) [anaconda.org](https://anaconda.org/)
channel for Linux, Windows and OSX respectively.

To manage the continuous integration and simplify feedstock maintenance
[conda-smithy](https://github.com/conda-forge/conda-smithy) has been developed.
Using the ``conda-forge.yml`` within this repository, it is possible to re-render all of
this feedstock's supporting files (e.g. the CI configuration files) with ``conda smithy rerender``.

For more information please check the [conda-forge documentation](https://conda-forge.org/docs/).

Terminology
===========

**feedstock** - the conda recipe (raw material), supporting scripts and CI configuration.

**conda-smithy** - the tool which helps orchestrate the feedstock.
                   Its primary use is in the construction of the CI ``.yml`` files
                   and simplify the management of *many* feedstocks.

**conda-forge** - the place where the feedstock and smithy live and work to
                  produce the finished article (built conda distributions)


Updating python-feedstock
=========================

If you would like to improve the python recipe or build a new
package version, please fork this repository and submit a PR. Upon submission,
your changes will be run on the appropriate platforms to give the reviewer an
opportunity to confirm that the changes result in a successful build. Once
merged, the recipe will be re-built and uploaded automatically to the
`conda-forge` channel, whereupon the built conda packages will be available for
everybody to install and use from the `conda-forge` channel.
Note that all branches in the conda-forge/python-feedstock are
immediately built and any created packages are uploaded, so PRs should be based
on branches in forks and branches in the main repository should only be used to
build distinct package versions.

In order to produce a uniquely identifiable distribution:
 * If the version of a package **is not** being increased, please add or increase
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string).
 * If the version of a package **is** being increased, please remember to return
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string)
   back to 0.

Feedstock Maintainers
=====================

* [@chrisburr](https://github.com/chrisburr/)
* [@isuruf](https://github.com/isuruf/)
* [@jakirkham](https://github.com/jakirkham/)
* [@katietz](https://github.com/katietz/)
* [@mbargull](https://github.com/mbargull/)
* [@msarahan](https://github.com/msarahan/)
* [@ocefpaf](https://github.com/ocefpaf/)
* [@pelson](https://github.com/pelson/)
* [@scopatz](https://github.com/scopatz/)
* [@xhochy](https://github.com/xhochy/)

