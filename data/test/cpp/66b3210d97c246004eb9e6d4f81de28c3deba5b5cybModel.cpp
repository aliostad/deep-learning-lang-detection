#include "cybUpdateModel.h"
#include "cybModel.h"

CybMultiModel *CybModel::getModels()  {
	return &models;
}

void CybModel::setDevice(CybDevice *device) {
	this->device = device;
}

CybDevice *CybModel::getDevice() {
	return device;
}

void CybModel::setUpdate(CybUpdateModel *u)  {
	pUpdate = u;
}

CybUpdateModel *CybModel::getUpdate() {
	return pUpdate;
}

void CybModel::update() {
	pUpdate->update(getDevice(), this);
} 

bool CybModel::loadModels(string arModels[], int numModels) {
	 return models.loadModels(arModels, numModels);	
}

bool CybModel::addModel(string model) {
	return models.addModel(model);
}

void CybModel::drawModel(int meshID) {
	models.drawModel(meshID);
}


CybModel::~CybModel() {}
