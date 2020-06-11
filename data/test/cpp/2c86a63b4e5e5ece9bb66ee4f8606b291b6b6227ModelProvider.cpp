#include "ModelProvider.h"
#include "FoodModel.h"
#include "SpecialFoodModel.h"
#include "GateModel.h"
#include "WallModel.h"
#include "PortalModel.h"
#include "GameStaticSettings.h"
#include "PacmanModel.h"
#include "GhostModel.h"

ModelProvider::ModelProvider(void)
{
}


ModelProvider::~ModelProvider(void)
{
}

ObjectModel * ModelProvider::GetItemModel(BoardItemType type)
{
	switch(type)
	{
	case FoodType : return new FoodModel();
	case SpecialFoodType : return new SpecialFoodModel();
	case PortalType : return new PortalModel();
	case Walls : return new WallModel();
	case GhostGate : return new GateModel(GATEOPENING_ANIMATION_DURATION);
	}
	return NULL;
}

AnimatedObjectModel * ModelProvider::GetAnimatedItemModel(BoardItemType type)
{
	ObjectModel * model = GetItemModel(type);
	if(model != NULL)
		return dynamic_cast<AnimatedObjectModel *>(model);
	return NULL;
}

EntityModel * ModelProvider::GetEntityModel(EntityTypeFlag type)
{
	switch(type)
	{
	case PacmanEntity : return new PacmanModel(WALKING_ANIMATION);
	case GhostEntity : return new GhostModel(WALKING_ANIMATION);
	}
	return NULL;
}