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


%typemap(out) IloIntArray IloTupleSchema::_getColumnTypes {
  int size = $1.getSize();
  $result = PyList_New(size); // use however you know the size here
  for (int i = 0; i < size; ++i) {
#ifdef ILO_PORT_WIN64
    PyList_SetItem($result, i, PyLong_FromLong($1[i]));
#else
     PyList_SetItem($result, i, PyLong_FromLongLong($1[i]));
#endif
  }
  $1.end();
}


%extend IloTupleSchema {
	 IloIntArray _getColumnTypes(){
		const IloTupleSchemaI* schema = (*self).getImpl();
		IloEnv env = (*self).getEnv();
		IloIntArray fields(env, schema->getTotalColumnNumber());
		for (IloInt i=0; i< fields.getSize(); i++){
		   fields[i] = 0;
		}
		IloIntArray ints = schema->getSharedIntColsAbsIdx();
		IloIntArray nums = schema->getSharedNumColsAbsIdx();
		IloIntArray strings = schema->getSharedSymbolColsAbsIdx();
		if (ints.getImpl() != 0){
		  for (IloInt i=0; i< ints.getSize(); i++){
			 fields[ints[i]] = 1;
		  }
		}
		if (nums.getImpl() != 0){
		  for (IloInt i=0; i< nums.getSize(); i++){
			 fields[nums[i]] = 2;
		  }
		}
		if (strings.getImpl() != 0){
		  for (IloInt i=0; i< strings.getSize(); i++){
			 fields[strings[i]] = 3;
		  }
		}
		return fields;
	 }
	IloBool _hasSubTuple() const{
	    return (*self).getImpl()->hasSubTuple();
	}
	IloTupleSchema _getTupleColumn(IloInt i) const{
	    return (*self).getImpl()->getTupleColumn(i);
	}
	IloBool _isTuple(IloInt i){
	    return (*self).getImpl()->isTuple(i);
	}
	IloBool hasKey() const{
		return (*self).getImpl()->hasKey();
	}
}

class IloTupleSchema{
public:
	const char* getColumnName(IloInt idx) const;
	IloInt getSize() const;
	const char* getName();
};
