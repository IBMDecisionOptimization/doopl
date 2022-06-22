/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(package="doopl") opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilconcert/iloenv.h"
#include "ilconcert/ilosymbol.h"
#include <ilopl/ilooplmodeli.h>
#include "ilopl/ilooplmodel.h"
%}

%extend IloEnv {
 IloOplModel _createOplModel(IloOplModelSource modelSource){
    IloEnv env = (*self);
    IloOplErrorHandler errHandler = IloOplErrorHandler(env);
    IloOplSettings settings = IloOplSettings(env, errHandler);
    IloOplModelDefinition mydef = IloOplModelDefinition(modelSource, settings);
    if (mydef.isUsingCP()){
        IloCP cp = IloCP(env);
        return IloOplModel(mydef, cp);
    }

    IloCplex cplex = IloCplex(env);
    return IloOplModel(mydef, cplex);
 }
}
class IloEnv{
public:
  IloEnv();
	 void end();
	 IloSymbol makeSymbol(const char * key) const ;
};
