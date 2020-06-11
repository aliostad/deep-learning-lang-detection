#include "EntityModel.h"
#include "ResourceModel.h"
#include "ResourceTexture.h"
#include "ResourceManager.h"

EntityModel::EntityModel(std::string name)
{
	this->name = name;
}


EntityModel::~EntityModel(void)
{
}

void EntityModel::Initialize(Renderer* renderer)
{
	this->model = ResourceManager::Instance()->GetModel(this->modelFileName, renderer->GetDevice());
}

void EntityModel::Cleanup()
{

}

void EntityModel::Update(Timer* timer)
{

}

void EntityModel::Render(Renderer* renderer)
{

}

Matrix EntityModel::GetPosition()
{
	return position;
}

void EntityModel::SetPosition(Matrix pos)
{
	position = pos;
}

float EntityModel::GetHRotation()
{
	return position.rotation_h;
}

void EntityModel::SetHRotation(float rotation)
{
	position.rotation_h = rotation;
}

float EntityModel::GetVRotation()
{
	return position.rotation_v;
}

void EntityModel::SetVRotation(float rotation)
{
	position.rotation_v = rotation;
}

ResourceModel* EntityModel::GetModel()
{
	return model;
}

void EntityModel::SetModel(ResourceModel* model)
{
	this->model = model;
}

void EntityModel::SetModel(std::string fileName)
{
	this->modelFileName = fileName;
}

ResourceTexture* EntityModel::GetTexture()
{
	return texture;
}

void EntityModel::SetTexture(ResourceTexture* texture)
{
	this->texture = texture;
}

void EntityModel::SetTexture(std::string fileName)
{
	this->textureFileName = fileName;
}

std::string EntityModel::GetName()
{
	return name;
}

bool EntityModel::CanUpdate()
{
	return false;
}

bool EntityModel::CanRender()
{
	return true;
}