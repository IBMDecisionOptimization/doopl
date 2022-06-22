/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(doopl) opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilopl/ilooplelementdefinition.h"
%}


%extend IloOplElementDefinition {
   IloBool isTupleSet(){
     IloOplElementDefinitionType::Type elttype = (*self).getElementDefinitionType();
      if (elttype != IloOplElementDefinitionType::SET){
           return IloFalse;
      }
      IloOplElementDefinitionType::Type subtype = (*self).asSet().getItem().getElementDefinitionType();
      if (subtype != IloOplElementDefinitionType::TUPLE){
           return IloFalse;
      }
     return IloTrue;
   }
}


class IloOplElementDefinition{
public:
		typedef IloOplElementDefinitionType::Type Type;
	  IloOplSetDefinition asSet() const;
		IloInt getElementDefinitionType_asInt() const;
		IloOplTupleDefinition asTuple() const;
		const char* getName() const;
		IloBool isExternalData() const;
};

class IloOplSetDefinition{
public:
	IloOplElementDefinition getItem() const;
};

class IloOplTupleDefinition{
public:
  		IloOplTupleSchemaDefinition getTupleSchema() const;
};
