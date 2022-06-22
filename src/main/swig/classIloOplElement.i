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
#include <ilopl/ilooplmodeli.h>
#include "ilopl/ilooplelement.h"
#include "ilopl/ilooplelementdefinition.h"
%}
class IloOplElement{
public:
  IloEnv getEnv() const ;
	const char * getName() const ;
	IloOplElementType::Type getElementType() const ;
	IloNum asNum() const ;
	IloInt asInt() const ;
	const char * asString() const ;
	IloTupleSet asTupleSet() const ;
	IloDiscreteDataCollection asDiscreteDataCollection() const ;
	IloBool isDiscreteDataCollection() const ;
	IloBool isDecisionExpression() const ;
	IloBool isExternalData() const ;
	IloBool isInternalData() const ;
	IloBool isPostProcessing() const ;
};
