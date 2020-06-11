//
//  LoadScene.cpp
//  LengendOfFightDemons
//
//  Created by RockLee on 14-4-15.
//
//

#include "LoadScene.h"
#include "LOFDConfigManager.h"

NS_LOFD_BEGIN

LoadContext * LoadContext::create(std::string typeValue, std::string pathValue)
{
    LoadContext * loadContext = new LoadContext(typeValue, pathValue);
    if (loadContext != nullptr)
    {
        loadContext->autorelease();
        return loadContext;
    }
    else
    {
        delete loadContext;
        loadContext = nullptr;
        return nullptr;
    }
}

LoadConfigContext * LoadConfigContext::create(std::string typeValue, std::string pathValue, std::string configTypeValue)
{
    LoadConfigContext * loadConfigContext = new LoadConfigContext(typeValue, pathValue, configTypeValue);
    if (loadConfigContext != nullptr)
    {
        loadConfigContext->autorelease();
        return loadConfigContext;
    }
    else
    {
        delete loadConfigContext;
        loadConfigContext = nullptr;
        return nullptr;
    }
}

LoadTextureAndPlistContext * LoadTextureAndPlistContext::create(std::string typeValue, std::string pathName, std::string fileFormat)
{
    LoadTextureAndPlistContext * context = new LoadTextureAndPlistContext(typeValue, pathName, fileFormat);
    if (context != nullptr)
    {
        context->autorelease();
        return  context;
    }
    else
    {
        delete context;
        context = nullptr;
        return nullptr;
    }
}

LoadTextureContext * LoadTextureContext::create(std::string typeValue, std::string pathValue)
{
    LoadTextureContext * context = new LoadTextureContext(typeValue, pathValue);
    if (context != nullptr)
    {
        context->autorelease();
        return context;
    }
    else
    {
        delete context;
        context = nullptr;
        return nullptr;
    }
}

void LoadScene::setLoadContexts(cocos2d::Vector<lofd::LoadContext *> loadContextsValue)
{
    if (isLoading) {
        cocos2d::log("load scene also start");
        return;
    }
    loadContexts = loadContextsValue;
}

void LoadScene::start()
{
    if (isLoading) {
        cocos2d::log("load scene also start");
        return;
    }
    
    this->currentIndex = 0;
    
    this->processRect.size.width = this->currentIndex * this->maxProcessLength / this->loadContexts.size();
    
    if (this->currentIndex < loadContexts.size())
    {
        this->load(this->loadContexts.at(this->currentIndex));
    }
    else
    {
        cocos2d::log("load complete");
    }
}

void LoadScene::onEnterTransitionDidFinish()
{
    Scene::onEnterTransitionDidFinish();
    this->start();
}

void LoadScene::draw(cocos2d::Renderer *renderer, const kmMat4 &transform, bool transformUpdated)
{
    Scene::draw(renderer, transform, transformUpdated);
    _customCommand.init(_globalZOrder);
    _customCommand.func = CC_CALLBACK_0(LoadScene::onDraw, this, transform, transformUpdated);
    renderer->addCommand(&_customCommand);
}

bool LoadScene::init()
{
    Scene::init();
    
    this->label = cocos2d::LabelTTF::create("loading", "Arial", 24);
    this->label->setPosition(cocos2d::Point(500, 300));
    this->addChild(this->label);
    
    return true;
}

void LoadScene::onDraw(const kmMat4 &transform, bool transformUpdated)
{
    kmGLPushMatrix();
    kmGLLoadMatrix(&transform);
    
    //draw
    CHECK_GL_ERROR_DEBUG();
    
    cocos2d::DrawPrimitives::setDrawColor4B(255, 255, 0, 255);
    glLineWidth(1);
    cocos2d::Point filledVertices[] = { cocos2d::Point(processRect.getMinX(), processRect.getMinY())
        , cocos2d::Point(processRect.getMinX(), processRect.getMaxY())
        , cocos2d::Point(processRect.getMaxX(), processRect.getMaxY())
        , cocos2d::Point(processRect.getMaxX(), processRect.getMinY())};
    cocos2d::DrawPrimitives::drawSolidPoly(filledVertices, 4, cocos2d::Color4F(0.5f, 0.5f, 1, 1 ));
    
    CHECK_GL_ERROR_DEBUG();
}

void LoadScene::load(lofd::LoadContext * loadContextValue)
{
    if (loadContextValue->type == TYPE_CONFIG_JSON)
    {
        loadConfigJson(loadContextValue);
    }
    else if (loadContextValue->type == TYPE_TEXTURE_PLIST)
    {
        loadTextureAndPlist(loadContextValue);
    }
    else if (loadContextValue->type == TYPE_TEXTURE)
    {
        loadTexture(loadContextValue);
    }
}

void LoadScene::loadConfigJson(lofd::LoadContext * loadContextValue)
{
    lofd::LoadConfigContext * loadConfigContext = (lofd::LoadConfigContext *) loadContextValue;
    std::string fullPath = cocos2d::FileUtils::getInstance()->fullPathForFilename(loadContextValue->path);
    std::string configData = cocos2d::FileUtils::getInstance()->getStringFromFile(fullPath);
    lofd::ConfigManager::getInstance()->createConfig(loadConfigContext->configType, configData);
    
    this->label->setString(loadContextValue->path);
    
    this->loadComplete();
}

void LoadScene::loadTextureAndPlist(lofd::LoadContext * loadContextValue)
{
    lofd::LoadTextureAndPlistContext * loadTextureAndPlistContext = (lofd::LoadTextureAndPlistContext *) loadContextValue;
    std::string fullPath = cocos2d::FileUtils::getInstance()->fullPathForFilename(loadTextureAndPlistContext->texturePath);
    cocos2d::Director::getInstance()->getTextureCache()->addImageAsync(fullPath, CC_CALLBACK_1(LoadScene::loadTextureAndPlistAsyncHandler, this));
    
    this->label->setString(loadContextValue->path);
//    this->loadComplete();
}

void LoadScene::loadTextureAndPlistAsyncHandler(cocos2d::Texture2D *textureValue)
{
    lofd::LoadTextureAndPlistContext * loadTextureAndPlistContext = (lofd::LoadTextureAndPlistContext *)this->loadContexts.at(this->currentIndex);
    cocos2d::log("%s", loadTextureAndPlistContext->plistPath.c_str());
    std::string fullPath = cocos2d::FileUtils::getInstance()->fullPathForFilename(loadTextureAndPlistContext->plistPath);
    cocos2d::log("%s", fullPath.c_str());
    cocos2d::SpriteFrameCache::getInstance()->addSpriteFramesWithFile(fullPath, textureValue);
    
    this->label->setString(loadTextureAndPlistContext->path + "---complete");
    
    this->loadComplete();
}

void LoadScene::loadTexture(lofd::LoadContext * loadContextValue)
{
    std::string fullPath = cocos2d::FileUtils::getInstance()->fullPathForFilename(loadContextValue->path);
    cocos2d::Director::getInstance()->getTextureCache()->addImageAsync(fullPath, CC_CALLBACK_1(LoadScene::loadTextureHandler, this));
    
    this->label->setString(loadContextValue->path);
}

void LoadScene::loadTextureHandler(cocos2d::Texture2D *textureValue)
{
    this->loadComplete();
}

void LoadScene::calculatePrecent()
{
    this->processRect.size.width = this->currentIndex * this->maxProcessLength / this->loadContexts.size();
}

void LoadScene::loadComplete()
{
    this->currentIndex ++;
    
    calculatePrecent();
    
    if (this->currentIndex < loadContexts.size())
    {
        this->load(this->loadContexts.at(this->currentIndex));
    }
    else
    {
        totalLoadComplete();
    }
}

void LoadScene::totalLoadComplete()
{
    cocos2d::log("load complete");
    
}
NS_LOFD_END;