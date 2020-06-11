/************************************************************************************************
  Computation_Model.cpp
  Contributor(s): E. Zeynep Erson
  Created on:      31-Jul-2007
  Description:	Computation_Models define the way the mathematical models are solved. Based on the mathematical model
				description, following types of computation models can be chosen:
				1. Continous time:
					a. Euler method
					b. Runge-Kutta method
				2. Discrete time:
				3. Discrete event:
*************************************************************************************************/

#include "computational_layer.h"

using namespace computational_layer;
Computation_Model::Computation_Model(){
	is_DE = false;

}

Computation_Model::~Computation_Model(){

}

bool Computation_Model::get_is_DE(){
	return is_DE;
}

double Computation_Model::run_Computation(double variable, Mathematical_Model* m){
	return 0.;
}

Mathematical_Model* Computation_Model::get_model(){
	return this->model;
}

void Computation_Model::set_model(Mathematical_Model *model){
	this->model = model;
}