# Anaconda Internal Documentation

## Testing Python

When you build a new version of python you need to test a few things. Here's a testing
plan that you should follow.

1. Push your newly built python package to our testing channel (`c3i_test2`).
2. Create a new Conda environment using this new python version: `conda create -n test -c c3i_test2 python=VERSION`
3. Make sure interactive python works: `python -i`
4. Make sure that the standard http server works: `python -m http.server --bind 127.0.0.1`
5. Build a python dependent package with this version of python. Good examples are `pyarrow` or `scipy`.
