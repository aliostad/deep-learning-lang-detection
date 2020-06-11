#include "Loader.h"

cocos2d::SpriteFrameCache* Loader::mFrameCache = nullptr;

void Loader::loadEverything()
{
	loadSounds();
	loadTextures();
	loadAnimations();
	loadObjects();
}

void Loader::loadSounds()
{
//	CocosDenshion::SimpleAudioEngine::getInstance()->preloadEffect("");
//	CocosDenshion::SimpleAudioEngine::getInstance()->preloadBackgroundMusic("mfx/");
}

void Loader::loadTextures()
{
	mFrameCache = cocos2d::SpriteFrameCache::getInstance();
	mFrameCache->retain();
	mFrameCache->addSpriteFramesWithFile("spritesheet.plist");
}

void Loader::loadAnimations()
{
	
}

void Loader::loadObjects()
{
	
}
