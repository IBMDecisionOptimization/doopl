# --------------------------------------------------------------------------
# Source file provided under Apache License, Version 2.0, January 2004,
# http://www.apache.org/licenses/
# (c) Copyright IBM Corp. 2022
# --------------------------------------------------------------------------

"""
This example shows how to run an OPL model, get a post processing IloTupleSet as a pandas df and iterate on it.
"""
from doopl.factory import *
from sample_utils import *


with create_opl_model(model=make_sample_opl_mod_abs_path(basename='Iterators')) as opl:
    opl.run()
    solution_table = opl.get_table("solution")
    for t in solution_table.itertuples(index=False):
        print(t)
