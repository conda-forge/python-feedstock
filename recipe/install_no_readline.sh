# ${SYS_PYTHON} ${RECIPE_DIR}/brand_python.py

make install
pyver=3.7
ln -s $PREFIX/bin/python${pyver} $PREFIX/bin/python
ln -s $PREFIX/bin/pydoc${pyver} $PREFIX/bin/pydoc
rm $PREFIX/lib/python${pyver}/lib-dynload/readline*
