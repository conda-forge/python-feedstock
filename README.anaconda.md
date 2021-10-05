# Anaconda Internal Documentation

## Testing Python

When you build a new version of python you need to test a few things. Here's a testing
plan that you should follow.

**On each supported platform do the following:**

1. Push your newly built python package to our testing channel (`c3i_test2`).
2. Create a new Conda environment using this new python version: `conda create -n test -c c3i_test2 python=VERSION`
3. Make sure interactive python works, and can import some built in modules (`re`, `math`, `os`):
```
$ python -i
Python 3.8.8 (default, Apr 13 2021, 12:59:45)
[Clang 10.0.0 ] :: Anaconda, Inc. on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import re
>>>
```
4. Make sure that the standard http server doesn't throw errors: `python -m http.server --bind 127.0.0.1`
5. `conda-build` a python dependent package with this version of python. Good examples are `pyarrow` or `scipy`.
