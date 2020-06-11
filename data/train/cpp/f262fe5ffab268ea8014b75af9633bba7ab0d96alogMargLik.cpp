/*
 * logMargLik.cpp
 *
 *  Created on: 21.06.2011
 *      Author: daniel
 */

#include <rcppExport.h>
#include <dataStructure.h>

using namespace Rcpp;

SEXP
cpp_logMargLik(SEXP R_modelConfig,
               SEXP R_modelData)
{
    // translate config into ModelPar
    ModelPar modelPar(as<NumericVector>(R_modelConfig));

    // convert the modelData object:
    ModelData modelData(R_modelData);

    // convert the other arguments:
    double R2 = 0.0;
    const double ret = modelData.getLogMargLik(modelPar, R2);

    return wrap(ret);
}

