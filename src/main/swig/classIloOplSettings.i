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
#include "ilopl/ilooplsettings.h"
%}
class IloOplSettings{
public:
  IloOplSettings(IloEnv env, IloOplErrorHandler handler);
  void setSkipWarnNeverUsedElements(IloBool value);
  void setProfiler(IloOplProfiler profiler);
  IloBool hasProfiler() const;
  IloOplProfiler getProfiler() const;
  void setExportExternalData(const char* path);
  void setExportInternalData(const char* path);
  void setWithNames(IloBool);
  IloOplErrorHandler getErrorHandler() const;
  //void end();
};
