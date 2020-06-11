#include "ModelManager.h"

#include "RenderStructs.h"
#include "Model.h"
#include "ModelManager.h"

ModelManager::ModelManager()
{
}

ModelManager::~ModelManager()
{
	if (m_models.size() > 0)
		purgeModels();
}

int ModelManager::addModel(Model* model)
{
	m_models.push_back(model);

	return 0;
}

int ModelManager::addModel(Mesh mesh)
{
	Model* model = new Model();
	model->mesh = mesh;
	m_models.push_back(model);

	return 0;
}

void ModelManager::purgeModels()
{
	for (Model* model : m_models)
		delete model;
	
	m_models.clear();
}

Model* ModelManager::model(int id)
{
	return m_models[id];
}