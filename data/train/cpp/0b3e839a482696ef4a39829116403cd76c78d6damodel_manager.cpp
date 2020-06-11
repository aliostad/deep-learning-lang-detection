#include "model_manager.h"

const std::string ModelManager::MODEL_CUBE = "cube";
const std::string ModelManager::MODEL_NANOSUIT = "nanosuit";
const std::string ModelManager::MODEL_M4 = "m4";

const std::string ModelManager::MODEL_PATH = "Resources/Models/";

ModelManager ModelManager::instance = ModelManager();

ModelManager& ModelManager::getInstance()
{
	return ModelManager::instance;
}

ModelManager::ModelManager()
{

}

void ModelManager::preloadModels()
{
	this->load(ModelManager::MODEL_CUBE, new Model(MODEL_PATH + "cube/sphere.obj"));
	this->load(ModelManager::MODEL_M4, new Model(MODEL_PATH + "M4/m4a1_s.fbx"));
	//this->load(ModelManager::MODEL_NANOSUIT, new Model(MODEL_PATH + "nanosuit/nanosuit.obj"));
}

void ModelManager::dispose()
{
	for (auto model : this->items)
	{
		model.second->dispose();
		delete model.second;
	}

	this->items.clear();
}