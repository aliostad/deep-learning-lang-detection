#include "ModelManager.h"

#include "../Model/ModelParser.h"


ModelManager::ModelManager()
{
}


ModelManager::~ModelManager()
{
	//! TODO: Clear
}

Model* ModelManager::Get(std::string modelFileName)
{
	Model* model = _modelMap[modelFileName];

	if (!model)
	{
		model = LoadModel(modelFileName);

		_modelMap[modelFileName] = model;
	}

	return model;
}

Model* ModelManager::LoadModel(std::string modelFileName)
{
	ModelParser Loader;

	Model* model = Loader.GetModel(modelFileName.c_str());

	printf("Model %s is loaded.\n", modelFileName.c_str());

	return model;
}