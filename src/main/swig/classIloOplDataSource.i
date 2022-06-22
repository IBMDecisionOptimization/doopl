%module(package="doopl") opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilconcert/iloenv.h"
#include <ilopl/iloopldatasource.h>
#include <ilopl/iloopldatasourcei.h>
%}

/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/


class IloOplDataSourceBaseI : public IloOplDataSourceI {
public:
   IloOplDataSourceBaseI(IloEnv env):IloOplDataSourceI(env.getImpl()) {}
   virtual ~IloOplDataSourceBaseI();
	  virtual void read() const =0;
    IloOplDataHandler getDataHandler() const;
};

%feature("director") IloOplDataSourceWrapper;
%inline
{
class IloOplDataSourceWrapper : public IloOplDataSourceBaseI{
public:
 IloOplDataSourceWrapper(IloEnv env) : IloOplDataSourceBaseI(env) {   }
 virtual ~IloOplDataSourceWrapper(){
 }
 virtual void read() const {
   throw new IloWrongUsage("implement me !");
 }
};
}

%feature("director:except") {
	if ($error != NULL) {
		throw Swig::DirectorMethodException();
	}
}

%exception {
    try { $action }
    catch (Swig::DirectorException&) {
	    SWIG_fail;
    }
}


class IloOplDataSource{
public:
 IloEnv getEnv() const ;
	 //void end();
	  IloOplDataSource(IloOplDataSourceBaseI * impl=0);
	  IloOplDataSource(IloEnv env, const char * filename);
	 void setDataHandler(IloOplDataHandler handler);
	 IloOplDataHandler getDataHandler() const ;
	 void setErrorHandler(IloOplErrorHandler handler);
	 IloOplErrorHandler getErrorHandler() const ;
	 void read() const ;
	 const char * getDataSourceName() const ;
};
