/*
 * Model.cpp
 *
 *  Created on: May 27, 2014
 *      Author: mirt
 */

#include "Model.h"

Model::Model ()
{
	parameterModel = NULL;
	itemModel = NULL;
	dimensionModel = NULL;
	itemParametersEstimated = false;
	type = 0;
}

void Model::setModel(ModelFactory * modelFactory, int modelType, int dimtype)
{
	parameterModel = modelFactory->createParameterModel(modelType);
	itemModel = modelFactory->createItemModel();
	dimensionModel = modelFactory->createDimensionModel(dimtype);
	itemParametersEstimated = false;
	type = modelType;
}

Model::~Model()
{
    delete parameterModel;
    delete itemModel;
    delete dimensionModel;
}

DimensionModel* Model::getDimensionModel(){ return (dimensionModel);}

void Model::setDimensionModel(DimensionModel* dimensionModel) { this->dimensionModel = dimensionModel; }

ItemModel* Model::getItemModel() { return (itemModel); }

ParameterModel* Model::getParameterModel() { return (parameterModel); }

void Model::setParameterModel(ParameterModel* parameterModel) { this->parameterModel = parameterModel; }

void Model::successProbability(QuadratureNodes* q) { parameterModel->successProbability(dimensionModel, q); }

void Model::buildParameterSet() { parameterModel->buildParameterSet(itemModel, dimensionModel); }

void Model::printParameterSet(ostream& k) { parameterModel->printParameterSet(k); }

int Model::Modeltype(){ return (type); }
