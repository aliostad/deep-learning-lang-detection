#include "Model.h"
#include "Team.h"
#include "CollisionContainer.h"

bool Model::init()
{
	_collisionContainer = nullptr;
	_modelPosition = cocos2d::Vec3(0, 0, 0);
	_modelVelocity = cocos2d::Vec3(0, 0, 0);
	_modelDampeningFactor = 1;
	_modelHealth = 1;
	_modelTeam = Team::NEUTRAL;
	return true;
}

void Model::setCollisionContainer(CollisionContainer* collisionContainer)
{
	if (_collisionContainer != nullptr)
	{
		_collisionContainer->release();
	}
	_collisionContainer = collisionContainer;
	_collisionContainer->retain();
}

void Model::update(float deltaTime)
{
	_modelPosition += _modelVelocity;
	_modelVelocity *= _modelDampeningFactor;
	if (_collisionContainer != nullptr)
	{
		_collisionContainer->setPosition(_modelPosition);
	}
}
