#include "stdafx.h"
#include "ModelsManager.h"
using namespace BasicEngine;
using namespace Managers;
using namespace Rendering;

Models_Manager::Models_Manager()
{
	
}

Models_Manager::~Models_Manager()
{

	for (auto model: gameModelList)
	{
		delete model.second;
	}
	gameModelList.clear();

	for (auto model : gameModelList_NDC)
	{
		delete model.second;
	}
	gameModelList_NDC.clear();
}

void Models_Manager::Update()
{
	for (auto model: gameModelList)
	{
		model.second->Update();
	}
	for (auto model : gameModelList_NDC)
	{
		model.second->Update();
	}
}

//NDC
void Models_Manager::Draw()
{
	for (auto model : gameModelList_NDC)
	{
		model.second->Draw();
	}
}

void Models_Manager::Draw(const glm::mat4& projection_matrix, const glm::mat4& view_matrix)
{
	for (auto model : gameModelList)
	{
		model.second->Draw(projection_matrix, view_matrix);
	}
}

void Models_Manager::DeleteModel(const std::string& gameModelName)
{

	IGameObject* model = gameModelList[gameModelName];
	model->Destroy();
	gameModelList.erase(gameModelName);

}

void Models_Manager::DeleteModel_NDC(const std::string& gameModelName)
{

	IGameObject* model = gameModelList_NDC[gameModelName];
	model->Destroy();
	gameModelList_NDC.erase(gameModelName);

}

IGameObject& Models_Manager::GetModel(const std::string& gameModelName) const
{
	return (*gameModelList.at(gameModelName));
}

IGameObject& Models_Manager::GetModel_NDC(const std::string& gameModelName) const
{
	return (*gameModelList_NDC.at(gameModelName));
}


IGameObject* Models_Manager::GetModelPointer(const std::string& gameModelName) const
{
	return gameModelList.at(gameModelName);
}
void Models_Manager::SetModel(const std::string& gameObjectName, IGameObject* gameObject)
{
	gameModelList[gameObjectName.c_str()] = gameObject;
}

