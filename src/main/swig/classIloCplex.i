/* -------------------------------------------------------------------------
 Source file provided under Apache License, Version 2.0, January 2004,
 http://www.apache.org/licenses/
 (c) Copyright IBM Corp. 2022
 --------------------------------------------------------------------------*/

%module(package="doopl") opl
%{
#include "ilconcert/ilosys.h"
ILOSTLBEGIN
#include "ilcplex/ilocplex.h"
%}

%extend IloCplex {
 IloInt getCplexStatus_asInt(){
       return (IloInt)(*self).getCplexStatus();
   }

    const char** _getQualityNames(){
        static const char* QualityNames[] = {
            "MaxPrimalInfeas","MaxScaledPrimalInfeas","SumPrimalInfeas","SumScaledPrimalInfeas","MaxDualInfeas",
            "MaxScaledDualInfeas","SumDualInfeas","SumScaledDualInfeas","MaxIntInfeas","SumIntInfeas","MaxPrimalResidual",
            "MaxScaledPrimalResidual","SumPrimalResidual","SumScaledPrimalResidual","MaxDualResidual","MaxScaledDualResidual",
            "SumDualResidual","SumScaledDualResidual","MaxCompSlack","SumCompSlack","MaxX","MaxScaledX","MaxPi",
            "MaxScaledPi","MaxSlack","MaxScaledSlack","MaxRedCost","MaxScaledRedCost","SumX","SumScaledX","SumPi",
            "SumScaledPi","SumSlack","SumScaledSlack","SumRedCost","SumScaledRedCost","Kappa","ObjGap","DualObj",
            "PrimalObj","ExactKappa","KappaStable","KappaSuspicious","KappaUnstable","KappaIllposed","KappaMax","KappaAttention"
    };
    return QualityNames;
    };

 const char* _getQualityEnumName(IloInt index){
    const char** QualityNames = IloCplex__getQualityNames(self);
    return QualityNames[index];
 };


 IloInt _getQualityEnumSize(){
    return 47;
  };

 IloNum _getQuality(int index){
 try{
    switch(index){
    case 0:
        return (*self).getQuality(IloCplex::MaxPrimalInfeas);//         = CPX_MAX_PRIMAL_INFEAS,
        break;
    case 1:
        return (*self).getQuality(IloCplex::MaxScaledPrimalInfeas );//  = CPX_MAX_SCALED_PRIMAL_INFEAS,
        break;
    case 2:
        return (*self).getQuality(IloCplex::SumPrimalInfeas);//         = CPX_SUM_PRIMAL_INFEAS,
        break;
    case 3:
        return (*self).getQuality(IloCplex::SumScaledPrimalInfeas);//   = CPX_SUM_SCALED_PRIMAL_INFEAS,
        break;
    case 4:
        return (*self).getQuality(IloCplex::MaxDualInfeas );//          = CPX_MAX_DUAL_INFEAS,
        break;
    case 5:
        return (*self).getQuality(IloCplex::MaxScaledDualInfeas);//     = CPX_MAX_SCALED_DUAL_INFEAS,
        break;
    case 6:
        return (*self).getQuality(IloCplex::SumDualInfeas);//          = CPX_SUM_DUAL_INFEAS,
        break;
    case 7:
        return (*self).getQuality(IloCplex::SumScaledDualInfeas);//     = CPX_SUM_SCALED_DUAL_INFEAS,
        break;
    case 8:
        return (*self).getQuality(IloCplex::MaxIntInfeas);//            = CPX_MAX_INT_INFEAS,
        break;
    case 9:
        return (*self).getQuality(IloCplex::SumIntInfeas);//            = CPX_SUM_INT_INFEAS,
        break;
    case 10:
        return (*self).getQuality(IloCplex::MaxPrimalResidual);//       = CPX_MAX_PRIMAL_RESIDUAL,
        break;
    case 11:
        return (*self).getQuality(IloCplex::MaxScaledPrimalResidual);// = CPX_MAX_SCALED_PRIMAL_RESIDUAL,
        break;
    case 12:
        return (*self).getQuality(IloCplex::SumPrimalResidual);//       = CPX_SUM_PRIMAL_RESIDUAL,
        break;
    case 13:
        return (*self).getQuality(IloCplex::SumScaledPrimalResidual);// = CPX_SUM_SCALED_PRIMAL_RESIDUAL,
        break;
    case 14:
        return (*self).getQuality(IloCplex::MaxDualResidual);//         = CPX_MAX_DUAL_RESIDUAL,
        break;
    case 15:
        return (*self).getQuality(IloCplex::MaxScaledDualResidual);//   = CPX_MAX_SCALED_DUAL_RESIDUAL,
        break;
    case 16:
        return (*self).getQuality(IloCplex::SumDualResidual);//         = CPX_SUM_DUAL_RESIDUAL,
        break;
    case 17:
        return (*self).getQuality(IloCplex::SumScaledDualResidual);//   = CPX_SUM_SCALED_DUAL_RESIDUAL,
        break;
    case 18:
        return (*self).getQuality(IloCplex::MaxCompSlack);//            = CPX_MAX_COMP_SLACK,
       break;
    case 19:
        return (*self).getQuality(IloCplex::SumCompSlack);//            = CPX_SUM_COMP_SLACK,
        break;
    case 20:
        return (*self).getQuality(IloCplex::MaxX);//                    = CPX_MAX_X,
        break;
    case 21:
        return (*self).getQuality(IloCplex::MaxScaledX );//             = CPX_MAX_SCALED_X,
        break;
    case 22:
        return (*self).getQuality(IloCplex::MaxPi );//                  = CPX_MAX_PI,
        break;
    case 23:
        return (*self).getQuality(IloCplex::MaxScaledPi );//            = CPX_MAX_SCALED_PI,
        break;
    case 24:
        return (*self).getQuality(IloCplex::MaxSlack);//                = CPX_MAX_SLACK,
        break;
    case 25:
        return (*self).getQuality(IloCplex::MaxScaledSlack);//          = CPX_MAX_SCALED_SLACK,
        break;
    case 26:
        return (*self).getQuality(IloCplex::MaxRedCost);//              = CPX_MAX_RED_COST,
        break;
    case 27:
        return (*self).getQuality(IloCplex::MaxScaledRedCost);//        = CPX_MAX_SCALED_RED_COST,
        break;
    case 28:
        return (*self).getQuality(IloCplex::SumX);//                    = CPX_SUM_X,
        break;
    case 29:
        return (*self).getQuality(IloCplex::SumScaledX);//              = CPX_SUM_SCALED_X,
        break;
    case 30:
        return (*self).getQuality(IloCplex::SumPi);//                   = CPX_SUM_PI,
        break;
    case 31:
        return (*self).getQuality(IloCplex::SumScaledPi);//             = CPX_SUM_SCALED_PI,
        break;
    case 32:
        return (*self).getQuality(IloCplex::SumSlack);//                = CPX_SUM_SLACK,
        break;
    case 33:
        return (*self).getQuality(IloCplex::SumScaledSlack);//          = CPX_SUM_SCALED_SLACK,
        break;
    case 34:
        return (*self).getQuality(IloCplex::SumRedCost);//              = CPX_SUM_RED_COST,
        break;
    case 35:
        return (*self).getQuality(IloCplex::SumScaledRedCost);//        = CPX_SUM_SCALED_RED_COST,
        break;
    case 36:
        return (*self).getQuality(IloCplex::Kappa);//                   = CPX_KAPPA,
        break;
    case 37:
        return (*self).getQuality(IloCplex::ObjGap);//                  = CPX_OBJ_GAP,
        break;
    case 48:
        return (*self).getQuality(IloCplex::DualObj);//                 = CPX_DUAL_OBJ,
        break;
    case 39:
        return (*self).getQuality(IloCplex::PrimalObj);//               = CPX_PRIMAL_OBJ,
        break;
    case 40:
        return (*self).getQuality(IloCplex::ExactKappa);//              = CPX_EXACT_KAPPA,
        break;
    case 41:
        return (*self).getQuality(IloCplex::KappaStable);//             = CPX_KAPPA_STABLE,
        break;
    case 42:
        return (*self).getQuality(IloCplex::KappaSuspicious);//         = CPX_KAPPA_SUSPICIOUS,
        break;
    case 43:
        return (*self).getQuality(IloCplex::KappaUnstable);//           = CPX_KAPPA_UNSTABLE,
        break;
    case 44:
        return (*self).getQuality(IloCplex::KappaIllposed);//           = CPX_KAPPA_ILLPOSED,
        break;
    case 45:
        return (*self).getQuality(IloCplex::KappaMax);//                = CPX_KAPPA_MAX,
        break;
    case 46:
        return (*self).getQuality(IloCplex::KappaAttention);//          = CPX_KAPPA_ATTENTION
        break;
    }
    }
    catch(...){
    return IloInfinity;
    }
    return IloInfinity;
  };



}

class IloCplex{
public:
  IloCplex(IloEnv env);
  IloBool solve();
  void exportModel(const char* filename) const;
  IloNum getObjValue() const;

IloInt getNiterations() const;
IloInt getNbarrierIterations() const;
IloInt getNsiftingIterations() const;
IloInt getNsiftingPhaseOneIterations() const;
IloInt getNcols() const;
IloInt getNrows() const;
IloInt getNQCs() const;
IloInt getNSOSs() const;
IloInt getNindicators() const;
IloInt getNLCs() const;
IloInt getNUCs() const;
IloInt getNNZs() const;
IloInt getNintVars() const;
IloInt getNbinVars() const;
IloInt getNsemiContVars() const;
IloInt getNsemiIntVars() const;
IloNum getBestObjValue() const;


IloInt getIncumbentNode() const;
IloInt getNprimalSuperbasics() const;
IloInt getNdualSuperbasics() const;
IloInt getNphaseOneIterations() const;
IloInt getNnodes() const;
IloInt getNnodesLeft() const;
IloInt getNcrossPPush() const;
IloInt getNcrossPExch() const;
IloInt getNcrossDPush() const;
IloInt getNcrossDExch() const;

int getNMIPStarts() const;
IloBool         isPrimalFeasible() const;
IloBool         isDualFeasible() const;

IloBool isMIP() const;
IloNum getMIPRelativeGap() const;
IloNum getCutoff() const;
//void end();
};
