
if [[ ${c_compiler} =~ .*toolchain.* ]]; then
    cp ${RECIPE_DIR}/toolchain_build.sh do_build.sh
else
    cp ${RECIPE_DIR}/gcc_build.sh do_build.sh
fi
chmod +x do_build.sh
./do_build.sh

# There are some strange distutils files around. Delete them
rm -rf ${PREFIX}/lib/python${VER}/distutils/command/*.exe
