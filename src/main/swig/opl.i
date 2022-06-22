/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(moduleimport="from . import _opl") opl

%nodefaultctor;
%module(directors="1") opl
%include "exception.i"
%include "std_string.i" // for std::string typemaps
%include "stdint.i" // for std::string typemaps


#ifdef ILO_PORT_WIN64
%include "windows.i"
#define IloInt __int64
typedef IloInt IloBool;
%typemap(out) IloBool, const IloBool& {
  $result = PyBool_FromLong($1);
}
%typemap(out) IloInt, const IloInt& {
  $result = PyLong_FromLongLong($1);
}
#else
#define IloInt long
typedef IloInt IloBool;
//%apply long { IloInt, IloBool }
%typemap(out) IloBool, const IloBool& {
  $result = PyBool_FromLong($1);
}
%typemap(out) IloInt, const IloInt& {
  $result = PyInt_FromLong($1);
}
#endif

#define IloNum double



%{
	static PyObject* pIloExceptionInstance;
%}

%init %{
	pIloExceptionInstance = PyErr_NewException("_opl.IloException", NULL, NULL);
	Py_INCREF(pIloExceptionInstance);
	PyModule_AddObject(m, "IloException", pIloExceptionInstance);
%}

%pythoncode %{
	IloException = _opl.IloException;
%}

%exception {
	try {
		$action
	} catch (IloException &e) {
		PyErr_SetString(pIloExceptionInstance, const_cast<char*>(e.getMessage()));
		SWIG_fail;
	} catch (const std::exception & e) {
		SWIG_exception(SWIG_RuntimeError, (std::string("C++ std::exception: ") + e.what()).c_str());
	} catch (...)
	{
		SWIG_exception(SWIG_UnknownError, "C++ anonymous exception");
	}
}

%include classIloEnv.i
%include classIloSymbol.i
%include classIloStringArray.i
%include classIloAnyArray.i
%include classIloNumArray.i
%include classIloIntArray.i
%include classIloDiscreteDataCollection.i
%include classIloOplDataSource.i
%include classIloOplModelDefinition.i
%include classIloTupleSet.i
%include classIloTupleSchema.i
%include classIloTupleCellArray.i
%include classIloOplModel.i
%include classIloOplElement.i
%include classIloOplElementDefinition.i
%include classIloOplDataHandler.i
%include classIloOplErrorHandler.i
%include classIloOplModelSource.i
%include classIloOplProfiler.i
%include classIloOplSettings.i
%include classIloCP.i
%include classIloCplex.i
