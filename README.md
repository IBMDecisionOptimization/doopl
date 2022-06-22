# IBM&reg; OPL connector for Python (DOopl)

Welcome to the IBM® OPL connector for Python.
Licensed under the Apache License v2.0.

With this library, you can quickly and easily add the power of optimization to your Python application.
You can model your problems by using the OPL language and IDE, and integrate it in Python via Python/pandas/sql alchemy inputs/outputs.

Solving with CPLEX requires that IBM® ILOG CPLEX Optimization Studio 20.1 and up is installed on your machine.

The OPL connector for Python is not part of the official Decision Optimization portfolio, and as such IBM does not provide customer support.
It is a development tool to help with discovering Python and as such is not meant for application deployment in an enterprise environment.

The project is known to work on:
* Mac OSX 64: both Intel and arm64
* 64-bit Linux
* 64-bit Windows

### Prerequisites
* A C++ compiler aligned with CPLEX C++ libraries.
* Python version you want to support (with the following packages: six and pandas).
* A CPLEX Studio installation (with version >= 20.1)
* SWIG version 4.0.x, which you can download from from https://www.swig.org/download.html
* If you are on Windows, you will need to install the 'make' command and cygwin commands.

## Getting IBM&reg; ILOG CPLEX Optimization Studio

- You can get a free [Community Edition](https://www.ibm.com/products/ilog-cplex-optimization-studio)
 of CPLEX Optimization Studio, with limited solving capabilities in terms of problem size.

- Faculty members, research professionals at accredited institutions can get access to an unlimited version of CPLEX through the
 [IBM® Academic Initiative](http://ibm.biz/CPLEXonAI).


## Compile and Install the library

Edit the `generate/makefile` header, you need to configure the following variables:
```
COS_VERSION= 2210
COSDIR=/Applications/CPLEX_Studio221
PYTHON_TARGET = 3.8
PYTHON_HOME=/opt/anaconda3
SWIGDIR=/Users/vberaudi/Downloads/swig-4.0.2
```

There are makefiles in `generate/x64_win`, `generate/x64_linux` and `generate/x64_osx`,
corresponding to each platform.

In these directories, running `make` will build the project and run some tests.

If you are on an arm64 Mac machine, you must run `arch -x86_64 make` to generate compatible code.

As an alternative, you can also run the `make` command as follows:
`COSDIR=/Applications/CPLEX_Studio20101 COS_VERSION=2010 PYTHON_HOME=/opt/anaconda3 SWIGDIR=/opt/swig-4.0.2 make`
to directly overload the default makefile variables.

## Get the examples

* [Examples](https://github.com/IBMDecisionOptimization/doopl-examples)

## License

This library is delivered under the  Apache License Version 2.0, January 2004 (see LICENSE.txt).

## Starting point

The API is very compact and simple.
You must have the OPL binaries in your PATH/LD_LIBRARY_PATH or DYLD_LIBRARY_PATH, depending on your platform.
They are located in `<COSDIR>/opl/bin/<platform>` where
   * <COSDIR> is the installation directory of CPLEX Studio and should correspond
     to the variable you set in the makefile.
   * <platform> is your platform.

Here is short summary of the capabilities:
   * Inputs can be tuple lists, panda's dataframe, sql alchemy fetch statements.
   * Generate, solve and get output tuple sets as pandas' dataframes.
   * Get the CPLEX problem statistics and quality metrics for the solution
   * Convert all integer variables to floating point variables and vice-versa.
   * Run the conflict/relaxation mechanism.
   * Call the 'run seeds' diagnosis for CPLEX and CP Optimizer problems.

Each of these features are demonstrated with simple examples.

Here is a small example to start working with the API:

    from doopl.factory import *

    # Create an OPL model from a .mod file
    with create_opl_model(model="file.mod") as opl:
        # tuple can be a list of tuples, a pandas dataframe...
        opl.set_input("TupleSet1", tuples)

        # Generate the problem and solve it.
        opl.run()

        # Get the names of post processing tables
        print("Table names are: "+ str(opl.output_table_names))

        # Get all the post processing tables as dataframes.
        for name, table in iteritems(opl.report):
            print("Table : " + name)
            for t in table.itertuples(index=False):
                print(t)
