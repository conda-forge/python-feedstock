import site, sys, os

dirs_to_add = []
# Workaround for https://github.com/conda/conda/issues/14053
# Older conda versions install noarch: python packages in wrong places.
# For example python3.1 because older conda assumed python minor version
# will have only one digit. noarhc pkgs for freethreading builds are supposed
# to be installed into <prefix>/lib/python3.13t/site-packages, but conda
# installs them to <prefix>/lib/python3.13/site-packages.
# The workaround is to add all these wrong paths to sys.path using
# site.addsitedir so that cpython and other tools like pip know about these
# locations to check when importing packages and uninstalling packages.
# When installing packages, pip will use the correct location
# <prefix>/lib/python3.13t/site-packages.
if 't' in sys.abiflags:
    dirs_to_add.append(os.path.join(sys.prefix, 'lib', f'python3.{sys.version_info[1]}', 'site-packages'))
# Workaround for https://github.com/conda/conda/issues/10969
dirs_to_add.append(os.path.join(sys.prefix, 'lib', f'python3.1', 'site-packages'))
# A python version independent directory that ABI3 and noarch packages can use.
# This is unused at the moment, but keeping it here for experimentation.
dirs_to_add.append(os.path.join(sys.prefix, 'lib', f'python', 'site-packages'))

for d in dirs_to_add:
    if os.path.exists(d):
        site.addsitedir(d)
