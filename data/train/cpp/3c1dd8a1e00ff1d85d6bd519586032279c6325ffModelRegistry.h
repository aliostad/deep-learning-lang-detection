#ifndef MODELREGISTRY_H
#define MODELREGISTRY_H

#include <map>
#include <string>
#include "Model.h"
using namespace std;

class ModelRegistry {
private:
	map<string,Model *> models;

public:
	ModelRegistry() {}
	~ModelRegistry() { cleanup(); }
	void addModel(string name, Model *model) {models[name]=model;}
	Model *getModel(string name) {return models[name];}
	void cleanup() {
		map<string,Model *>::iterator i;
		for (i = models.begin(); i != models.end(); i++) {
			i->second->remove();
			delete i->second;
		}
	}
};

#endif