/*-----------------------------------------------------------------------------
Author: Bîrzu George
Email:	b.gxg7@yahoo.com
Date:	08-11-2015
-----------------------------------------------------------------------------*/

#include "ModelManager.h"

using namespace managers;
using namespace rendering;

ModelManager::ModelManager() { 
}

ModelManager::~ModelManager()
{
	/*for (auto model : modelList)
	{
		delete model.second;
	}
	modelList.clear();*/
}

void managers::ModelManager::createModel(rendering::interfaces::IModel* model, std::string modelName, GLuint program)
{
	model->setProgram(program);
	model->create();
	modelList[modelName] = model;
}

void ModelManager::deleteModel(const std::string& gameModelName)
{
	rendering::interfaces::IModel* model = modelList[gameModelName];
	model->destroy();
	modelList.erase(gameModelName);
}

const rendering::interfaces::IModel& ModelManager::getModel(const std::string& gameModelName) const
{
	return (*modelList.at(gameModelName));
}

void ModelManager::update()
{
	for (auto model : modelList)
	{
		model.second->update();
	}
}

void ModelManager::draw()
{
	for (auto model : modelList)
	{
		model.second->draw();
	}
}

void ModelManager::drawMini()
{
	for (auto model : modelList)
	{
		model.second->drawMini();
	}
}

glm::mat4 ModelManager::translate(float tx, float ty, float tz)
{
	return glm::transpose(glm::mat4(
		1, 0, 0, tx,
		0, 1, 0, ty,
		0, 0, 1, tz,
		0, 0, 0, 1
		));
}

glm::mat4 ModelManager::translateX(float t)
{
	return ModelManager::translate(t, 0, 0);
}

glm::mat4 ModelManager::translateY(float t)
{
	return ModelManager::translate(0, t, 0);
}

glm::mat4 ModelManager::translateZ(float t)
{
	return ModelManager::translate(0, 0, t);
}

glm::mat4 ModelManager::rotateX(float r)
{
	return glm::transpose(glm::mat4(
		1, 0, 0, 0,
		0, cos(r), -sin(r), 0,
		0, sin(r), cos(r), 0,
		0, 0, 0, 1
		));
}

glm::mat4 ModelManager::rotateY(float r)
{
	return glm::transpose(glm::mat4(
		cos(r), 0, -sin(r), 0,
		0, 1, 0, 0,
		sin(r), 0, cos(r), 0,
		0, 0, 0, 1
		));
}

glm::mat4 ModelManager::rotateZ(float r)
{
	return glm::transpose(glm::mat4(
		cos(r), -sin(r), 0, 0,
		sin(r), cos(r), 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1
		));
}

glm::mat4 ModelManager::scale(float sx, float sy, float sz)
{
	return glm::transpose(glm::mat4(
		sx, 0, 0, 0,
		0, sy, 0, 0,
		0, 0, sz, 0,
		0, 0, 0,  1
		));
}

glm::mat4 ModelManager::scaleX(float s)
{
	return ModelManager::scale(s, 1, 1);
}

glm::mat4 ModelManager::scaleY(float s)
{
	return ModelManager::scale(1, s, 1);
}

glm::mat4 ModelManager::scaleZ(float s)
{
	return ModelManager::scale(1, 1, s);
}