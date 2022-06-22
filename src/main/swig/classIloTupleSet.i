/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(doopl) opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilconcert/ilosymbol.h"
#include "ilopl/ilotuplecollection.h"
%}


%typemap(in) char ** {
  /* Check if is a list  */
  if (PyList_Check($input)) {
    int size = PyList_Size($input);
    int i = 0;
    $1 = (char **) malloc((size+1) * sizeof(char*));
    for (i = 0; i < size; i++) {
      PyObject *o = PyList_GetItem($input,i);
%#if PY_VERSION_HEX>=0x03000000
    PyObject *pystr;
    pystr = PyUnicode_AsUTF8String(o);
    $1[i] = strdup(PyBytes_AsString(pystr));
    Py_XDECREF(pystr);
%#else
    $1[i] = PyString_AsString(o);
%#endif
    }
    $1[i] = 0;
  }
}

%typemap(in) IloNum*{
  /* Check if is a list  */
  if (PyList_Check($input)) {
    int size = PyList_Size($input);
    int i = 0;
    $1 = (double*) malloc(size * sizeof(double));
    for (i = 0; i < size; i++) {
      PyObject *o = PyList_GetItem($input,i);
        $1[i] = PyFloat_AsDouble(o);
    }
  }
}


#ifdef ILO_PORT_WIN64
%typemap(in) IloInt*{
  /* Check if is a list  */
  if (PyList_Check($input)) {
    int size = PyList_Size($input);
    int i = 0;
    $1 = (int64_t*) malloc(size * sizeof(int64_t));
    for (i = 0; i < size; i++) {
      PyObject *o = PyList_GetItem($input,i);
        $1[i] = PyInt_AsLong(o);
    }
  }
}
#else
%typemap(in) IloInt*{
  /* Check if is a list  */
  if (PyList_Check($input)) {
    int size = PyList_Size($input);
    int i = 0;
    $1 = (long*) malloc(size * sizeof(long));
    for (i = 0; i < size; i++) {
      PyObject *o = PyList_GetItem($input,i);
        $1[i] = PyInt_AsLong(o);
    }
  }
}
#endif



%extend IloTupleSet {
 void setIntColumnValues(IloInt idx, IloInt* values, IloInt size){
    IloIntDataColumnI* c = (IloIntDataColumnI*)(*self).getImpl()->getSharedPointersToColumns()[idx];
     for (IloInt i=0; i< size; i++){
       c->add(values[i]);
     }
     delete values;
 }
 void setNumColumnValues(IloInt idx, IloNum* values, IloInt size){
    IloNumDataColumnI* c = (IloNumDataColumnI*)(*self).getImpl()->getSharedPointersToColumns()[idx];
     for (IloInt i=0; i< size; i++){
       c->add(values[i]);
     }
     delete values;
 }
 void setStringColumnValues(IloInt idx, char** values, IloInt size){
    IloAnyDataColumnI* c = (IloAnyDataColumnI*)(*self).getImpl()->getSharedPointersToColumns()[idx];
    IloEnv env = c->getEnv();
     for (IloInt i=0; i< size; i++){
       c->add(env.makeSymbol(values[i]).getImpl());
       delete values[i];
     }
     delete values;
 }


%typemap(out) IloIntArray IloTupleSet::getIntColumnValues {
  int size = $1.getSize();
  $result = PyList_New(size); // use however you know the size here
  for (int i = 0; i < size; ++i) {
#ifdef ILO_PORT_WIN64
    PyList_SetItem($result, i, PyLong_FromLong($1[i]));
#else
     PyList_SetItem($result, i, PyLong_FromLongLong($1[i]));
#endif
  }
}

%typemap(out) IloNumArray IloTupleSet::getNumColumnValues {
  int size = $1.getSize();
  $result = PyList_New(size); // use however you know the size here
  for (int i = 0; i < size; ++i) {
    PyList_SetItem($result, i, PyFloat_FromDouble($1[i]));
  }
}

%typemap(out) IloAnyArray IloTupleSet::getSymbolColumnValues {
  int size = $1.getSize();//sizeof($1)/sizeof(const char*);
  $result = PyList_New(size); // use however you know the size here
  for (int i = 0; i < size; ++i) {
    PyList_SetItem($result, i, PyString_FromString(((IloSymbolI*) $1[i])->getString()));
  }
}


 IloIntArray getIntColumnValues(IloInt i){
    IloIntDataColumnI* c = (IloIntDataColumnI*)(*self).getImpl()->getSharedPointersToColumns()[i];
    return c->getArray();
 }
 IloNumArray getNumColumnValues(IloInt i){
    IloNumDataColumnI* c = (IloNumDataColumnI*)(*self).getImpl()->getSharedPointersToColumns()[i];
    return c->getArray();
 }
 IloAnyArray getSymbolColumnValues(IloInt i){
    IloAnyDataColumnI* c = (IloAnyDataColumnI*)(*self).getImpl()->getSharedPointersToColumns()[i];
    return c->getArray().getImpl();
 }
 void fillTupleHash(){
   IloEnv env = (*self).getEnv();
   IloAnyFixedArray pointers = (*self).getImpl()->getSharedPointersToColumns();
   if (pointers.getSize() == 0) return;

   IloTupleCellArray cells(env, pointers.getSize());
   IloInt size = ((IloDiscreteDataCollectionI*)pointers[0])->getSize();
   for (IloInt i=0; i< size; i++){
     for (IloInt j=0; j<pointers.getSize(); j++){
       IloDiscreteDataCollectionI* column = (IloDiscreteDataCollectionI*)pointers[j];
       switch (column->getDataType()){
            case IloDataCollection::IntDataColumn:
                 cells[j] = ((IloIntDataColumnI*)column)->getArray()[i];
                 break;
            case IloDataCollection::NumDataColumn:
                 cells[j] = ((IloNumDataColumnI*)column)->getArray()[i];
                 break;
            default:
                 cells[j] = ((IloAnyDataColumnI*)column)->getArray()[i];
                 break;
       }
    }
    (*self).getImpl()->commit2HashTable(cells, IloFalse);
   }
   cells.end();
  }
}

class IloTupleSet{
public:
	IloTupleSchema getSchema() const ;
	IloInt getSize() const;
	IloInt commit(IloTupleCellArray line, IloBool check);
	void end();
	IloInt commit2HashTable(IloTupleCellArray array, IloBool check);
 void fillColumns();
};
