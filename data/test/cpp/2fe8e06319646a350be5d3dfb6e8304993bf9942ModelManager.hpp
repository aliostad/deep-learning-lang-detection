#pragma once

#include "stdafx.h"

#include <luapath\luapath.hpp>

class Model;
class SkinnedModel;

/**@brief A singleton class that manages the lifetime of the loaded Model intances.
The model is associated by its name in the lua config file
*/
class ModelManager
{
public:
	static ModelManager& get();
	/**Deletes the list of Models*/
	~ModelManager();
	/**Get a static model */
	Model* getModel(const std::string &modelName);
	/** Get a model with a bone hierarchy*/
	SkinnedModel* getSkinnedModel(const std::string &modelName);

private:
	ModelManager();
private:
	//!< associate each Model with a unique name. To get a SkinnedModel upcast the returned model from the map
	typedef std::map<std::string, Model*> modelMap;

	modelMap models;
};