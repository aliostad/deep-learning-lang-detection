#include "model_factory.h"
#include "..\tests\test_http.h"
#include "..\models\in_app.h"
#include "..\models\powers.h"
#include "..\models\stats.h"
#include "..\models\user.h"

ModelFactory * ModelFactory::_modelFactory = NULL;

ModelFactory::ModelFactory(){

}

ModelFactory::~ModelFactory(){

}

ModelFactory * ModelFactory::getModelFactory(){
	if(!_modelFactory)
		_modelFactory = new ModelFactory();

	return _modelFactory;
}

void ModelFactory::destroyModelFactory(){
	if(_modelFactory)
		delete _modelFactory;

	_modelFactory = NULL;
}

Model * ModelFactory::createModelObject(string _type){
	if(_type == "test"){
		return new HttpTest();
	}else if(_type == "in_app"){
		return new InAppModel();
	}else if(_type == "powers"){
		return new PowersModel();
	}else if(_type == "stats"){
		return new StatsModel();
	}else if(_type == "user"){
		return new UserModel();
	}
}