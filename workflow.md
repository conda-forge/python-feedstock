## Helper bash script to automatically apply the patches

This script should be placed at the root of the CPython git repo. It is
functionally harmless. The checkout is just creating a detached head. When you
find a patch that fails to apply the workflow should be:

1. checkout the v3.9.7 tag
2. Apply the patch to confirm it fails
3. checkout the v3.9.6 tag
4. Apply the patch to confirm it works. Commit that change. Keep track of the sha from that commit
5. Checkout the v3.9.7 tag
6. Cherry pick the commit from step 4
7. Fix up the diff
8. Format a new patch (`git format-patch v3.9.7`)
9. Copy the patch to the feedstock/recipe/patches dir to overwrite the patch that needs to be replaced
10. Commit the patch from step 9
11. Run the script again from the root of the CPython directory and make sure the new patch applies. If any
    more failures, go back to step #1 with the failing patch

```bash
#!/bin/bash
set -eou
# Set this to an appropriate directory
patches_dir="/Users/ericdill/dev/cf/python-feedstock/recipe/patches"
# Set this to the tag you want to make sure things apply to
starting_tag="v3.9.7"

git co ${starting_tag}

for file in $(ls $patches_dir | sort); do
    echo "--------------------------------"
    echo "--------------------------------"
    echo "Testing patch: ${file}"
    echo "--------------------------------"
    echo "--------------------------------"
    cmd="/Users/ericdill/miniconda/envs/cb/bin/patch -Np1 -i ${patches_dir}/${file} --binary"
    echo cmd=${cmd}
    ${cmd}
    git commit -am "Applied $file"
done
```