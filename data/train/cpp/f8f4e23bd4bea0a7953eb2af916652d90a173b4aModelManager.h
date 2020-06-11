#pragma once
#ifndef MODELMANAGER_H
#define MODELMANAGER_H

#include "Model.h"
#include "ModelLoader.h"
#include "../../ScreenEnums.h"
#include "TextureManager.h"
using namespace std;

class ModelManager
{
private:
	ModelManager(ID3D11Device* Device);
	static	ModelManager*	gInstance;
	static	bool			IsInitialized(void);

	ID3D11Device*	gDevice;
	TextureManager	gTextureManager;

	map <string, Model*>			gLoadedModels;
	map <string, Model*>::iterator	gModelIterator;

public:
	~ModelManager(void);
	static	void			Initialize(ID3D11Device* Device);
	static	ModelManager*	GetInstance(void);

	Model*	GetModel(string Name);
	void	LoadModel(string Name, string Filename, string ModelPath, string TexturePath);
	void	LoadModel(string Name, string Filename, string Path);

	ModelInstance*	CreateModelInstance(string ModelName);
};

#endif