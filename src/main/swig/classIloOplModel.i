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
#include "ilopl/ilooplmodel.h"
%}


%extend IloOplModel {
   IloBool hasMain() const {
   return (*self).getImpl()->hasMain();
   }
   static IloOplModelSource _makeModelSourceFromString(IloEnv env, const char* model){
        std::istringstream* in = new (env) std::istringstream( model );
        IloOplModelSource modelSource(env,*in,"carseq");
        return modelSource;
    }
   void _compile(const char* name) {
        IloOplCompiler compiler((*self).getEnv());
        ofstream ofs(name,ios::binary);
        compiler.compile((*self).getModelDefinition().getModelSource(),ofs);
        ofs.close();
    }

    IloNumArray _getDuals(const char* name){
       IloNumArray arr((*self).getEnv());
       if ((*self).hasElement(name)){
          IloOplElement elt = (*self).getElement(name);
          if (elt.isMap()){
            if (elt.getElementType()==IloOplElementType::MAP_CONSTRAINT){
               IloConstraintMap m = elt.asConstraintMap();
               IloMapIterator it(m.getImpl());
               while (it.ok()) {
                    IloConstraintArray a(it.getCurrentEltArray());
                    IloConstraint ct = a[it.getCurrentDeepestIndex()];
                    if (ct.getName()) arr.add( (*self).getImpl()->getSolutionGetter().getDual(ct) );
                    ++it;
               }
            }
          }
          else{
            IloConstraint m = elt.asConstraint();
            if (m.getName()) arr.add( (*self).getImpl()->getSolutionGetter().getDual(m) );
          }
       }
       return arr;
    }
    IloNumArray _getSlacks(const char* name){
       IloNumArray arr((*self).getEnv());
       if ((*self).hasElement(name)){
          IloOplElement elt = (*self).getElement(name);
          if (elt.isMap()){
            if (elt.getElementType()==IloOplElementType::MAP_CONSTRAINT){
              IloConstraintMap m = elt.asConstraintMap();
               IloMapIterator it(m.getImpl());
               while (it.ok()) {
                    IloConstraintArray a(it.getCurrentEltArray());
                    IloConstraint ct = a[it.getCurrentDeepestIndex()];
                    if (ct.getName()) arr.add( (*self).getImpl()->getSolutionGetter().getSlack(ct) );
                    ++it;
               }
            }
          }
          else{
            IloConstraint m = elt.asConstraint();
            if (m.getName()) arr.add( (*self).getImpl()->getSolutionGetter().getSlack(m) );
          }
       }
       return arr;
    }
    IloNumArray _getReducedCosts(const char* name){
       IloNumArray arr((*self).getEnv());
       if ((*self).hasElement(name)){
          IloOplElement elt = (*self).getElement(name);
          if (elt.isMap()){
              IloNumVarMap m = elt.asNumVarMap();
               IloMapIterator it(m.getImpl());
               while (it.ok()) {
                    IloNumVarArray a(it.getCurrentEltArray());
                    IloNumVar ct = a[it.getCurrentDeepestIndex()];
                    if (ct.getName()) arr.add( (*self).getImpl()->getSolutionGetter().getReducedCost(ct) );
                    ++it;
            }
          }
          else{
            IloNumVar m = elt.asNumVar();
            if (m.getName()) arr.add( (*self).getImpl()->getSolutionGetter().getReducedCost(m) );
          }
       }
       return arr;
    }


    IloStringArray _getNames(const char* name){
       IloStringArray arr((*self).getEnv());
       if ((*self).hasElement(name)){
          IloOplElement elt = (*self).getElement(name);
          if (elt.isMap()){
            IloMapI* m = 0;
            if (elt.getElementType()==IloOplElementType::MAP_CONSTRAINT){
               m = elt.asConstraintMap().getImpl();
            }
            else if (elt.getElementType()==IloOplElementType::MAP_INT)
               m = elt.asIntVarMap().getImpl();
            else
               m = elt.asNumVarMap().getImpl();
            IloMapIterator it(m);
            while (it.ok()) {
               IloExtractableArray a(it.getCurrentEltArray());
               IloExtractable ct = a[it.getCurrentDeepestIndex()];
               if (ct.getName())
                 arr.add( ct.getName() );
               ++it;
            }
          }
          else{
            IloExtractable ct = 0;
            if (elt.getElementType()==IloOplElementType::MAP_CONSTRAINT){
               ct = elt.asConstraint();
            }
            else if (elt.getElementType()==IloOplElementType::MAP_NUM)
               ct = elt.asNumVar();
            else
               ct = elt.asIntVar();
            if (ct.getName())
                 arr.add( ct.getName() );
          }
       }
       return arr;
    }

    void _installEngineLog(const char* path) {
      class tee_streambuf : public streambuf {
        streambuf* _tee;
        streambuf* _tee2;
        protected:
            virtual int sync() {
            	int t1 = _tee->pubsync();
            	int t2 = _tee2->pubsync();
            	return (t1==0 && t2==0)?0:-1;
            }
        public:
            tee_streambuf(streambuf* tee, streambuf* tee2) : streambuf(), _tee(tee), _tee2(tee2) {
            }
            virtual int overflow(int c) {
                _tee->sputc(c);
                _tee2->sputc(c);
                return c;
            }
        };

        class tee_ostream : public ostream {
	        public:
	        tee_ostream(IloEnv env, ostream& tee, ostream& tee2) : ostream(new (env) tee_streambuf(tee.rdbuf(),tee2.rdbuf())) {
	            }
	        virtual ~tee_ostream() {
	            delete rdbuf();
	        }
        };
        ostream* _logStream = new ((*self).getImpl()->getEnv()) ofstream(path);
        ostream* _teeStream = new ((*self).getImpl()->getEnv())  tee_ostream(((*self).getImpl()->getEnv()) , (*self).getImpl()->getAlgorithm().out(),*_logStream);
        (*self).getImpl()->getAlgorithm().setOut(*_teeStream);
   }

   void _flushEngineLogs() {
        (*self).getImpl()->getAlgorithm().out().flush();
   }

    IloInt _printConflict(){
        return (*self).printConflict(cout);
    }
    IloInt _printRelaxation(){
        return (*self).printRelaxation(cout);
    }

    void applyOpsSettings(const char* opsFile){
       (*self).getImpl()->applyOpsSettings(0, opsFile);
   }

   void mute(){
   (*self).getImpl()->getAlgorithm().setOut((*self).getEnv().getNullStream());
   }
   void unmute(){
   (*self).getImpl()->getAlgorithm().setOut(cout);
   }
   IloBool hasMain(){
    return (*self).getImpl()->hasMain();
   }
}

class IloOplModel{
public:
 IloInt main();
 IloEnv getEnv() const ;
 IloOplModelDefinition getModelDefinition() const ;
 void addDataSource(IloOplDataSource source);
 IloOplElement getElement(const char * name);
 IloStringArray getElementNamesInPostProcessing() const ;
 IloModel getModel();
 IloObjective getObjective();
 void convertAllIntVars();
 void unconvertAllIntVars();
 IloCplex getCplex() const ;
 IloCP getCP() const ;
 IloBool hasCplex() const ;
 IloBool hasCP() const ;
 IloBool isUsingCplex() const ;
 IloBool isUsingCP() const ;
 void generate();
 IloBool isGenerated() const ;
 void postProcess();
 IloOplSettings getSettings() const;
 void runSeed(IloInt n);
 };
