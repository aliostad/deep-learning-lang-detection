#include "ModelManager.h"


ModelManager::ModelManager(int aniLen, string aniFolder)
	:_aniLens(aniLen)
	, _aniFolder(aniFolder)
{
	this->initModels();
}


ModelManager::~ModelManager()
{
	for (auto & _model : _models)
		delete _model;
}

void ModelManager::initModels()
{
	string fileName;
	_models.resize(_aniLens, 0);
	for (auto i = 0; i < _aniLens; i++){
		fileName = _aniFolder + "/" + "frame" + to_string(i+1)+".ply";
		cout << fileName << endl;
		Model * pModel = new Model(fileName,i);
		pModel->moveToOrigin();
		this->addModel(pModel);
	}
}

void ModelManager::addModel(Model *pModel)
{
	_models[pModel->getId()] = pModel;
}

Model* ModelManager::getModel(int id)
{
	return _models[id];
}