/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(package="doopl") opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilcp/cp.h"
%}
class IloCP{
public:
  IloCP(IloEnv env);
  IloBool solve() const;
  IloNum getObjValue() const;
  void exportModel(const char* filename) const;
};
