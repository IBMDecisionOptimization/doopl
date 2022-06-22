/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(doopl) opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilconcert/iloenv.h"
#include <ilopl/ilooplmodeldefinition.h>
%}


class IloOplModelDefinition {
public:
  IloBool hasElementDefinition(const char* name) const;
  IloOplElementDefinition getElementDefinition(const char* name) const;
};
