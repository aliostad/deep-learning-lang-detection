#include "PlaceModelState.h"
#include "misc/helper.h"
#include "misc/windowsHead.h"
//
#include "render/math.h"
//
#include "model/EntityInstance.h"
//
#include "scene/Terrain.h"
#include "scene/SceneManager.h"
#include "scene/Chunk.h"
#include "scene/QuadNode.h"
//
#include "Global.h"
#include "misc/EventManager.h"
#include "font/FlowText.h"
#include "EventArgs.h"
void PlaceModelState::update()
{
	if (ModelShadow_)
	{
		Vector2 pp = getSceneManager()->getPickingPoint();
		ModelShadow_->setPosition(Vector3(pp.x, 0.0f, pp.y));
		PlaceModelDlgPositionChangedEventArgs args;
		args.Postion_ = ModelShadow_->getPosition();
		EventManager::GetInstance().fireEvent(PlaceModelDlgPositionChangedEventArgs::tEventName, args);
	}
}

PlaceModelState::~PlaceModelState()
{

}

PlaceModelState::PlaceModelState()
{
	type_ = eState_PlaceModel;
	ModelShadow_ = NULL;
	ModelSelected_ = NULL;
}

void PlaceModelState::enter()
{
	
}

void PlaceModelState::leave()
{
	
}

void PlaceModelState::destroy()
{
}

void PlaceModelState::setModelFile( const tstring& mf )
{
	//ModelFile_ = "model\\";
	ModelFile_ = mf;
	std::ostringstream ss;
	ss<<"放置物件："<<ModelFile_;
	FlowText::getSingletonP()->add(ss.str(), Vector4(1, 1, 1, 1));
	ModelShadow_ = getSceneManager()->addEntityInstance(ModelFile_);
	ModelShadow_->setScale(Vector3(1.f, 1.f, 1.f));
	PlaceModelDlgFileChangedEventArgs args;
	EventManager::GetInstance().fireEvent(PlaceModelDlgFileChangedEventArgs::tEventName, args);
}

tstring PlaceModelState::getModelFile()
{
	return ModelFile_;
}

void PlaceModelState::onMouseLeftButtonUp()
{
	//加入场景
	if (ModelShadow_)
	{
		ModelSelected_ = ModelShadow_;
		ModelShadow_ = NULL;
	}
	else
	{
		ModelSelected_ = getSceneManager()->getPickingEntityInstance();
	}
}

void PlaceModelState::onMouseRightButtonUp()
{
	//取消加入
	if (ModelShadow_)
	{
		getSceneManager()->removeEntityInstance(ModelShadow_);
		ModelShadow_ = NULL;
	}
}

void PlaceModelState::setPosition( const Vector3& p )
{
	if (ModelSelected_)
	{
		ModelSelected_->setPosition(p);
	}
}

void PlaceModelState::setScale( const Vector3& p )
{
	if (ModelSelected_)
	{
		ModelSelected_->setScale(p);
	}
}

void PlaceModelState::setRotation( const Vector3& p )
{
	if (ModelSelected_)
	{
		ModelSelected_->rotateY(p.y);
	}
}
