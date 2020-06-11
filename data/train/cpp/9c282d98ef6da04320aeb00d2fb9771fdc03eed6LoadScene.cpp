//
//  LoadScene.cpp
//  PaoNiu
//
//  Created by 叶孙松 on 14-1-8.
//
//

#include "LoadScene.h"
#include "LoadLayer.h"

bool LoadScene::init(){
    if (!CCScene::init()) {
        return false;
    }
    
    CCTextureCache::sharedTextureCache()->addImage("fishingjoy_resource.png");
    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("fishingjoy_resource.plist");
    
    
    LoadDelegate* delegate=new LoadDelegate();
    
    LoadLayer* loadLayer=LoadLayer::create();
    loadLayer->setDelegate(delegate);
    addChild(loadLayer);
    
    return true;
}