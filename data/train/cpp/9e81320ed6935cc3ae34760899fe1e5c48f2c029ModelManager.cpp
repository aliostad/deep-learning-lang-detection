#define _CRT_SECURE_NO_WARNINGS
#include "ModelManager.h"
#include "Common.h"
#include "ShaderDevise.h"

ModelManager::ModelInfo::ModelInfo() {
	model = NULL;
}
ModelManager::ModelManager() {
}
ModelManager::~ModelManager() {
}
int ModelManager::load(std::string filename) {
	// Šm”F—p
	{
		FILE* fp = NULL;
		if(fp = fopen(filename.c_str(), "rt")) {
			fclose(fp);
		} else {
			return -1;
		}
	}
	ModelManager& mm = ModelManager::inst();
	for(int i = 0, len = mm.models.count(); i < len; i++) {
		if(mm[i].filename == filename) {
			return i;
		}
	}
	ModelInfo mi;
	mi.model = (new Model)->init(ShaderDevise::device(), filename);
	mm.models << mi;
	return mm.models.count() - 1;
}
Model* ModelManager::get(int i) {
	ModelManager& mm = ModelManager::inst();
	return mm[i].model;
}
void ModelManager::release() {
	ModelManager& mm = ModelManager::inst();
	for(int i = 0, len = mm.models.count(); i < len; i++) {
		if(mm[i].model) {
			mm[i].model->release();
			delete mm[i].model;
		}
	}
	mm.models.release();
}
ModelManager::ModelInfo ModelManager::operator[] (int i) {
	return models[i];
}
