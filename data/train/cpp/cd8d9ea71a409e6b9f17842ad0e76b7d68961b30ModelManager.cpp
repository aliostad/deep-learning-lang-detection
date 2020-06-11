#include "ModelManager.hpp"
#include "Model.hpp"

using std::string;
using std::vector;
using std::map;

ModelManager& ModelManager::get()
{
	static ModelManager singleton;
	return singleton;
}
ModelManager::~ModelManager()
{
	modelMap::iterator it = models.begin();
	for (; it != models.end(); ++it)
		delete it->second;
}


Model* ModelManager::getModel(const std::string &modelName)
{
	modelMap::iterator keyExists = models.find(modelName);
	if (keyExists == models.end())
	{
		luapath::Table modelsTable = luapath::LuaState("config/settings.lua").getGlobalTable("models");
		//the dot here signifies pattern recognition of luapath. '.' for string token '#' for number token
		Model *newModel = new Model(modelsTable.getTable(string(".") + modelName));
		models.insert(std::pair<std::string, Model*>(modelName, newModel));
		return newModel;
	}
	else
	{ 
		return keyExists->second;
	}
	
}

SkinnedModel* ModelManager::getSkinnedModel(const std::string &modelName)
{
	modelMap::iterator keyExists = models.find(modelName);
	if (keyExists == models.end())
	{
		luapath::Table modelsTable = luapath::LuaState("config/settings.lua").getGlobalTable("skinnedModels");
		SkinnedModel *newModel = new SkinnedModel(modelsTable.getTable(string(".") + modelName));
		models.insert(std::pair<std::string, Model*>(modelName, newModel));
		return newModel;
	}
	else //if already in map
	{	// to make it type safe make sure that the resulting Mesh* is the correct subclass of Mesh
		SkinnedModel *result = dynamic_cast<SkinnedModel*>(keyExists->second);
		if (!result)
			LOG(ERROR) << "model : " << modelName << "is not of type SkinnedModel" << std::endl;
		return result;
	}

}

ModelManager::ModelManager()
{

}