/*
 * Model.h
 *
 *  Created on: May 27, 2014
 *      Author: mirt
 */

#ifndef MODEL_H_
#define MODEL_H_

#include <model/parameter/ParameterModel.h>
#include <model/item/ItemModel.h>
#include <model/dimension/DimensionModel.h>
#include <model/ModelFactory.h>
#include <type/QuadratureNodes.h>
#include <string>
/**
 * Model class that holds the structures for the IRT models
 * can vary across parameters, items and dimensions
 * includes suport for dichotomic and polytomic models
 * multi and single dimensional models
 * future suport for multiscale and longitudinal models can be implemented.
 * */
class Model
{

	public:

	ParameterModel *parameterModel;
	ItemModel *itemModel;
	DimensionModel *dimensionModel;
	int type;
	//holds if the estimation has been completed.
	bool itemParametersEstimated;

	// Constructor
	Model();
	int Modeltype();
	// Methods
	void setModel (ModelFactory * , int, int);
	void successProbability (QuadratureNodes *);
	void buildParameterSet ();

	// Getters and Setters
	DimensionModel* getDimensionModel();
	void setDimensionModel(DimensionModel* dimensionModel);

	ItemModel* getItemModel();

	ParameterModel* getParameterModel();
	void setParameterModel(ParameterModel* parameterModel);

	void printParameterSet(ostream&);

	// Destructor
	virtual ~Model();
};

#endif /* MODEL_H_ */
