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
%}


%extend IloAnyArray {
  const char* get_String(IloInt index) {
       IloSymbolI* s = (IloSymbolI*) (*self)[index];
       return s->getString();
   }
}
class IloAnyArray{
public:
	IloInt getSize() const;
};
