#include "StaticEntity.hpp"
using namespace IscEngine;

StaticEntity::StaticEntity(Model* const model) : Entity() {

	this->models[0.f] = model;

}

void StaticEntity::addModel(const float distance, Model* const model) {

	this->models[distance] = model;

}

Model* StaticEntity::getModel(const float distance) {
	
	Model* model = this->models.begin()->second;
	for (auto it = this->models.begin(), end = this->models.end(); it != end; ++it) {
		if (distance >= (*it).first) {
			model = (*it).second;
		}
	}

	return model;

}