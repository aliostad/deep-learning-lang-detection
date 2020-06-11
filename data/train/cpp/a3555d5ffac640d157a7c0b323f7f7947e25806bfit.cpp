/*
 * fit.cpp
 *
 *  Created on: May 14, 2013
 *      Author: Thibaut Metivet
 */

#include "fit.hpp"

using namespace LQCDA;

// ----------------------------------------------------------------------
// Fit constructors and member functions
// ----------------------------------------------------------------------
Fit::Fit(FitModel* model) :
    _Model(model), _IsComputed(false),
    _ModelParams(model->nParams()), _ModelParamsErr(model->nParams())
{}
    
Fit::Fit(FitModel* model, const std::vector<ModelParam>& initPar) :
    _Model(model), _IsComputed(false),
    _ModelParams(initPar), _ModelParamsErr(model->nParams())
{}
	
Fit::Fit(FitModel* model, const std::vector<double>& initPar) :
    _Model(model), _IsComputed(false),
    _ModelParams(model->nParams()), _ModelParamsErr(model->nParams())
{
    for(int i = 0; i < initPar.size(); ++i) {
	_ModelParams[i].setValue(initPar[i]);
    }
}

void setInitModelParams(const std::vector<ModelParam>& initPar)
{
    _ModelParams = initPar;
    _IsComputed = false;
}
void setInitModelParams(const std::vector<double>& initPar)
{
    for(int i = 0; i < initPar.size(); ++i) {
	_ModelParams[i] = ModelParam(initPar[i]);
    }
    _IsComputed = false;
}
