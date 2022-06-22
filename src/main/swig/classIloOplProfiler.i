/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(doopl) opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilopl/ilooplprofiler.h"
%}

%extend IloOplProfiler {
 void printReport(){
       (*self).printReport(std::cout);
   }
}

class IloOplProfiler {
public:
    IloOplProfiler(IloEnv env);
    void setIgnoreUserSection(IloBool);
};
