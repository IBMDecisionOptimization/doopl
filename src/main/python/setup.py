# --------------------------------------------------------------------------
# Source file provided under Apache License, Version 2.0, January 2004,
# http://www.apache.org/licenses/
# (c) Copyright IBM Corp. 2022
# --------------------------------------------------------------------------

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


ext_modules = [Extension("factory", ["./doopl/factory.py"]),
               Extension("opl", ["./doopl/opl.py"]),
               Extension("version", ["./doopl/version.py"]),
               ]


setup(
  name = 'diet2',
  cmdclass = {'build_ext' : build_ext},
  ext_modules = ext_modules,
)
