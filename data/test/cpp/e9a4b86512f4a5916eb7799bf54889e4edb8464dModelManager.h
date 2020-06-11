/*
 * ModelManager.h
 *
 *  Created on: Feb 19, 2012
 *      Author: forb
 */

#include "shared.h"
#include "md2model.h"
#include <GL/gl.h>
#include <map>

#ifndef MODELMANAGER_H_
#define MODELMANAGER_H_

using namespace std;



class ModelManager	{

	map<string, model_t*> modelMap;

public:
	ModelManager();
	~ModelManager();

	bool addModel(string name);
	bool removeModel(string name);
	model_t* cloneModel(string name);
	int getModelCacheID(string name);
	model_t* getModel(string name);
};


#endif /* MODELMANAGER_H_ */
