import site, sys, os

dirs_to_add = []
# Workaround for https://github.com/conda/conda/issues/14053
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
