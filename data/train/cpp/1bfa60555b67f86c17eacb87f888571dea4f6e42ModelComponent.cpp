/************************************************************************
Author:		Dan Strycharske
Date:       02.12.12
File:       ModelComponent.cpp
Brief:      ModelComponent class implementation.
/************************************************************************/

#include "ModelComponent.h"
#include "Entity.h"
#include <cstdlib>
#include <share.h>


ModelComponent::ModelComponent() : ComponentDisciple()
{
	mModel = new Model;
	mModel->mParent = this->mParentRef;
}


ModelComponent::ModelComponent(const ModelComponent& comp) : ComponentDisciple(comp)
{
	mModel = new Model;
	mModel->mParent = comp.getModel()->mParent;
}


ModelComponent::~ModelComponent()
{
}

/************************************************************************/
/* Public - Member methods
/************************************************************************/
const Model* ModelComponent::getModel() const
{ 
	return mModel; 
}


#ifdef USE_LUA

LUA_START_DEFINE_CLASS(ModelComponent)
LUA_NAME_METHOD(ModelComponent, "SetOffsetPos", LSetOffsetPos )
LUA_END_DEFINE_CLASS


LUA_DEFINE_METHOD(ModelComponent, LSetOffsetPos)
{
	if( !ls ) { return 0;}

	float x = (float)lua_tonumber(ls, 1 );
	float y = (float)lua_tonumber(ls, 2 );
	float z = (float)lua_tonumber(ls, 3 );

	//this->SetOffsetPos(CVector3(x,y,z));

	return 0;
}


#endif