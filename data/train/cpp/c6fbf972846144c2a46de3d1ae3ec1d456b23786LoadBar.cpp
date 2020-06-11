//
// Created by Yuanfei He on 15/5/5.
//

#include "LoadBar.h"
#include "ui/CocosGUI.h"
#include "cocostudio/CocoStudio.h"


USING_NS_CC;
using namespace cocostudio;
using namespace cocos2d::ui;

bool LoadBar::initWithFile(const std::string &file) {

    _rootNode = CSLoader::getInstance()->createNodeWithFlatBuffersFile(file);
    _loadBar = static_cast<cocos2d::ui::LoadingBar*>(_rootNode->getChildByName("loadedBar"));
    addChild(_rootNode);
    setContentSize(_rootNode->getContentSize());

    _loadAsset = new LoadAssert(this);
    this->setProgressValue(0);
    return true;
}


LoadBar *LoadBar::createWithLoadBar(const std::string &file) {
    auto load = new (std::nothrow)LoadBar();
    if(load && load->initWithFile(file))
    {
        load->autorelease();
        return load;
    }else CC_SAFE_DELETE(load);
    return nullptr;
}

void LoadBar::setProgressValue(int value) {
    _loadBar->setPercent(value);

}

void LoadBar::finish() {
    CCLOG("load finish...");
    if(_callfun)
    {
        _callfun();
    }
    removeFromParent();
}

void LoadBar::progress(int value) {
   this->setProgressValue(value);
}

LoadBar::~LoadBar() {
    CC_SAFE_DELETE(_loadAsset);
}

void LoadBar::startLoad(const std::vector<std::string> &value) {
    _loadAsset->startLoad(value);
}

void LoadBar::setCallBackFun(const LoadBar::CallBackFun &fun) {
    _callfun = fun;
}
