#include "RenderModelManager.h"

RenderModelManager* RenderModelManager::_instance = nullptr;

RenderModelManager* RenderModelManager::instance()
{
	if (_instance == nullptr) {
		_instance = new RenderModelManager();
	}
	return _instance;
}

void RenderModelManager::addRenderModel(RenderModel *model)
{
	_renderModels[model->name()] = model;
}

RenderModel *RenderModelManager::getRenderModel(const std::string &name)
{
	rendermodels_type::iterator it = _renderModels.find(name);
	if (it == _renderModels.end())
		return 0;
	return it->second;
}

RenderModelManager::~RenderModelManager()
{
	destroyModels();
}

void RenderModelManager::destroyModels()
{
	for (rendermodels_type::iterator it = _renderModels.begin();
		it != _renderModels.end();
		++it)
	{
		delete it->second;
	}
}