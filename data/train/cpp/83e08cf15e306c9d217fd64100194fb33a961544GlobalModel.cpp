//
//  GlobalModel.cpp
//  MMFighting
//
//  Created by yaodd on 13-12-27.
//
//

#include "GlobalModel.h"

static GlobalModel *pGlobalModel;
GlobalModel::GlobalModel()
{
    this->init();
}
GlobalModel::~GlobalModel()
{
//    delete pGlobalModel;
}

GlobalModel *GlobalModel::sharedGlobalModel()
{
    if (pGlobalModel == NULL) {
        pGlobalModel = new GlobalModel();
    }
    return pGlobalModel;
}

bool GlobalModel::init(){
    bool pRet = false;
    do {
        this->rankArray = CCArray::createWithCapacity(100);
        this->userHolder = new PlayerHolder();
        pRet = true;
    } while (0);
    
    return pRet;
}