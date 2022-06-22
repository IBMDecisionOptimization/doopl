/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(doopl) opl

%extend IloTupleCellArray{
 void setStringValue(IloInt index, char* value){
   IloEnv env = IloGetEnv((*self).getImpl()->getMemoryManager());
   IloSymbolI* s = env.makeSymbol(value).getImpl();
   (*self).setSymbolValue(index, s);
 }
}

class IloTupleCellArray{
public:
	IloTupleCellArray(IloEnv env);
	IloTupleCellArray(IloEnv env, IloInt size);
	void end();
	IloInt getSize() const ;
	//void clear();
	void setIntValue(IloInt index, IloInt value);
	void setNumValue(IloInt index, IloNum value);
	void setSymbolValue(IloInt index, IloSymbol value);
	IloInt getIntValue(IloInt index);
	IloNum getNumValue(IloInt index);
	IloSymbol getSymbolValue(IloInt index);
	IloBool isIntValue(IloInt index);
	IloBool isNumValue(IloInt index);
	IloBool isSymbolValue(IloInt index);
};
