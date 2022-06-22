/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(doopl) opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilconcert/ilostring.h"
%}

%extend IloStringArray {
  const char* get_String(IloInt index) {
       return (*self)[index];
   }
}
class IloStringArray{
public:
	IloInt getSize() const;
	void end();
};
