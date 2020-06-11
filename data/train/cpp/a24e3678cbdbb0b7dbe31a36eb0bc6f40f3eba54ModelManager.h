#pragma once
#include "Model.h"
#include <string>
#include <vector>
#include<iostream>
#include<fstream>

//////////////////////////////////////////////////////////////////////////
// Dinh nghia ID cua Model
// Xe tang cap 01
#define TANK_01 1
#define TANK_02 2
#define TANK_03 3
#define BULLET_01 4
#define BULLET_02 5
#define BULLET_03 6
//////////////////////////////////////////////////////////////////////////
class Model;
class ModelManager
{
protected:
	static ModelManager* m_instance;
	ModelManager(void);
protected:
	int m_CountModel;
	std::vector<Model*> m_arrModel;
	Model* LoadModel(int idModel);
	std::vector<char*> m_arrNameModel;
	void LoadNameModel();
public:
	
	static ModelManager* GetInstance();
	static void Init();
	static void Shutdown();
	Model* AddModel(int idModel);
	~ModelManager(void);
	
};
