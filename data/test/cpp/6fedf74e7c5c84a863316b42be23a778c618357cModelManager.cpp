/***
 * hesperus: ModelManager.cpp
 * Copyright Stuart Golodetz, 2009. All rights reserved.
 ***/

#include "ModelManager.h"

#include <hesp/io/files/ModelFiles.h>

namespace hesp {

//#################### PUBLIC METHODS ####################
const Model_Ptr& ModelManager::model(const std::string& modelName)	{ return resource(modelName); }
Model_CPtr ModelManager::model(const std::string& modelName) const	{ return resource(modelName); }
std::set<std::string> ModelManager::model_names() const				{ return resource_names(); }
void ModelManager::register_model(const std::string& modelName)		{ register_resource(modelName); }

//#################### PRIVATE METHODS ####################
Model_Ptr ModelManager::load_resource(const std::string& modelName) const
{
	return ModelFiles::load_model(modelName);
}

std::string ModelManager::resource_type() const
{
	return "model";
}

}
