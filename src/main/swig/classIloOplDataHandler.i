/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(package="doopl") opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilopl/iloopldatasource.h"
%}


%extend IloOplDataHandler {
 IloTupleSet _prepareSet(const char* name){
   (*self).startElement(name);
   (*self).startSet();
   (*self).endSet();
   (*self).endElement();
  return (*self).getElement(name).asTupleSet();
 }
}

class IloOplDataHandler{
public:
 IloEnv getEnv() const ;
 //void end();
 IloOplDataHandler(IloEnv env, IloOplSettings settings, ostream & outs);
 IloOplDataHandler(IloEnv env, ostream & outs);
 void startElement(const char * name);
 void endElement();
 void startSet();
 void endSet();
 IloOplElement getElement(const char * name) const ;
};
