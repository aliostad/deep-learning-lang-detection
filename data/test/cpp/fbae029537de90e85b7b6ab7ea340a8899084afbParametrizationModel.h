/*
 * ParametrizationModel.h
 *
 *  Created on: Apr 2, 2013
 *      Author: steve
 */

#ifndef PARAMETRIZATIONMODEL_H_
#define PARAMETRIZATIONMODEL_H_

#include "data/DataStructs.h"

#include <memory>

class Model;
class ModelPar;
class ModelParSet;

using std::shared_ptr;

/**
 * A #ParametrizationModel is a special type of #Model. It functions as a
 * parametrization to an existing parameter set of another #Model, but
 * describes these parameters as a function of the domain variables of the
 * actual fit function. So it behaves just like a #Model with the addition that
 * it requires a #ModelParSet in the constructor, which will be adjusted.
 */
class ParametrizationModel {
private:
  shared_ptr<Model> model;
  shared_ptr<ModelPar> model_par;
public:
  ParametrizationModel(shared_ptr<Model> model_);
  virtual ~ParametrizationModel();

  void parametrize(const DataStructs::data_point &point);

  void setModelPar(shared_ptr<ModelPar> model_par_);
  const shared_ptr<ModelPar> getModelPar() const;

  shared_ptr<Model> getModel();
};

#endif /* PARAMETRIZATIONMODEL_H_ */
