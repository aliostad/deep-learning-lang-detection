//
//  ModelManager.h
//  model
//
//  Created by Kosuke Takami on 2013/10/20.
//  Copyright (c) 2013年 Kosuke Takami. All rights reserved.
//

#ifndef __model__ModelManager__
#define __model__ModelManager__

#include <iostream>
//#include "ModelInstanceManager.h"
#include <map>
#include "ModelInstanceManager.h"
#include "PanelDataManager.h"
#include "EnemyDataManager.h"
#include "ItemMasterManager.h"
#include "EquipmentMasterManager.h"
#include "UserItemManager.h"
using namespace std;

class ModelManager {
    map< string, ModelInstanceManager* > *_modelMap;
    // model managerをつり下げる。
    void append(ModelInstanceManager *model);
    void remove(ModelInstanceManager *model);
    static ModelManager* _instance;
    ModelManager();
public:
    static ModelManager* getInstance();
    ModelInstanceManager* getModel(std::string name);
};

#endif /* defined(__model__ModelManager__) */