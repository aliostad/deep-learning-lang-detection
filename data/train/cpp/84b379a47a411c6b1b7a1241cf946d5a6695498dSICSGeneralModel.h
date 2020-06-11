/*
 * SICSGeneralModel.h
 *
 *  Created on: 17 Jun 2014
 *      Author: jlgpisa
 */

#ifndef SICSGENERALMODEL_H_
#define SICSGENERALMODEL_H_

#include <model/ModelFactory.h>
#include <model/parameter/ThreePLModel.h>
#include <model/parameter/TwoPLModel.h>
#include <model/parameter/OnePLModel.h>
#include <model/parameter/OnePLACModel.h>
#include <model/item/DichotomousModel.h>
#include <model/dimension/UnidimensionalModel.h>

class SICSGeneralModel : public ModelFactory
{

public:

	SICSGeneralModel();

	// Methods
	ParameterModel *createParameterModel(int model);
	ItemModel	   *createItemModel();
	DimensionModel *createDimensionModel(int dimstype);

	virtual ~SICSGeneralModel();
};

#endif /* SICSGENERALMODEL_H_ */
