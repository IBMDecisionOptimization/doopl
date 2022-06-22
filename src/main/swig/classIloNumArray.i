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

%extend IloNumArray {
  IloNum get_Num(IloInt index) {
       return (*self)[index];
   }
}
class IloNumArray{
public:
	IloInt getSize() const;
	void end();
};
