#include "ModelManager.h"
#include <vector>
#include "Model.h"


ModelManager::ModelManager()
{
}


ModelManager::~ModelManager()
{
}

void ModelManager::loadModel(const string& ModelName, string filename)
{
	if (this->ModelMap.find(ModelName) != this->ModelMap.end()) {
		return;
	}
	Model* model;
	model = new Model(ModelName);
	model->setLogger(this->logger);
	model->loadModel(filename);
	this->ModelMap[ModelName] = model;	
}

Model* ModelManager::getModel(const string& ModelName)
{
	Model* Model = nullptr;
	if (this->ModelMap.find(ModelName) != this->ModelMap.end()) {
		Model = this->ModelMap[ModelName];
	}
	return Model;

}