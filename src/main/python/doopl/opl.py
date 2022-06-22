# --------------------------------------------------------------------------
# Source file provided under Apache License, Version 2.0, January 2004,
# http://www.apache.org/licenses/
# (c) Copyright IBM Corp. 2022
# --------------------------------------------------------------------------

from ctypes.util import find_library
import os
import platform
import sys

try:
    from os import add_dll_directory
except ImportError:
    def add_dll_directory(_):
        pass


def _add_dll_dir_if_needed(lib):
    #
    # Since python 3.8, DLL dependenceins for extension modules are resolved
    # more securely. PATH is no longuer used, so we need to add CPLEX and OPL
    # dlls path with add_dll_directory()
    #
    if (platform.system() == "Windows" and
       sys.version_info[0] == 3 and sys.version_info[1] >= 8):
        opl_dll = find_library(lib)
        if opl_dll:
            where = os.path.dirname(opl_dll)
            # add_dll_directory() is only available on python 3.8 and windows,
            add_dll_directory(where)


# try sequence is ugly, but this is more friendly to code editors
try:
    _add_dll_dir_if_needed("opl2210")
    from doopl.internal.opl2210.opl import *
except:
    try:
        _add_dll_dir_if_needed("opl2010")
        from doopl.internal.opl2010.opl import *
    except:
        try:
            _add_dll_dir_if_needed("opl12100")
            from doopl.internal.opl12100.opl import *
        except ImportError:
            try:
                _add_dll_dir_if_needed("opl1290")
                from doopl.internal.opl1290.opl import *
            except ImportError:
                try:
                    _add_dll_dir_if_needed("opl1280")
                    from doopl.internal.opl1280.opl import *
                except Exception as u:
                    import traceback
                    traceback.print_exc()
                    raise ImportError('Could not import OPL wrappers. Make sure that OPL bin directory is in the PATH')



class OplRuntimeException(Exception):
    '''The exception thrown by doopl methods when an error occurs
    '''
    pass
