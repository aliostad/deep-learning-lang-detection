#include "Sprite3DView.h"
#include "Model.h"

using namespace cocos2d;

bool Sprite3DView::initWithModel(const Model* model)
{
	if (!View::init(model, Sprite3D::create()))
	{
		return false;
	}
	return true;
}

bool Sprite3DView::initWithModelAndFile(const Model* model, const std::string& modelPath)
{
	if (!View::init(model, Sprite3D::create(modelPath)))
	{
		return false;
	}
	return true;
}

Sprite3DView* Sprite3DView::createWithModelAndFile(const Model* model, const std::string& modelPath)
{
	Sprite3DView* pRet = new Sprite3DView();
	if (pRet && pRet->initWithModelAndFile(model, modelPath))
	{
		pRet->autorelease();
		return pRet;
	}
	delete pRet;
	pRet = nullptr;
	return nullptr;
}
