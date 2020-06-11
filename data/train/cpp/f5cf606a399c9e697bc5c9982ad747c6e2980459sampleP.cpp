#include "sampleParams.h"


void sampleP(mm_model_mcmc model)
{
    int i, s;
    double pPrior = 1.0;
    NumericVector pAlpha(model.getS() + 1);
    for(s = 0; s < model.getS() + 1; s ++){
        pAlpha[s] = pPrior;
    }

    for(i = 0 ; i < model.getT(); i++) {
        if(model.getStayerStatus(i) == 1) {
            pAlpha[model.getStayerMatch(i)] += 1.0;
        } else {
            pAlpha[model.getS()] += 1.0;
        }
    }

////    for(s = 0; s < model.getS() + 1; s ++){
////        Rcout << pAlpha[s] <<" " ;
////    }
//    Rcout <<std::endl;

    NumericVector target = rDirichlet(pAlpha);
    model.setP(target);
}

