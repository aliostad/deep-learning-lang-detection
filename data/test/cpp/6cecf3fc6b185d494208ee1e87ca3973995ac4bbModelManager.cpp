//
//  ModelManager.cpp
//  model
//
//  Created by Kosuke Takami on 2013/10/20.
//  Copyright (c) 2013年 Kosuke Takami. All rights reserved.
//

#include "ModelManager.h"
ModelManager* ModelManager::_instance = NULL;

void ModelManager::append(ModelInstanceManager *model){
    std::string name = model->getModelName();
    (*_modelMap)[name] = model;
}

void ModelManager::remove(ModelInstanceManager *model){
    std::string name = model->getModelName();
    (*_modelMap)[name] =NULL;
}

ModelInstanceManager* ModelManager::getModel(std::string name){
    if((*_modelMap)[name]){
        return (*_modelMap)[name];
    }
    // ここで
    // new nameとか出来ればいいけど。
    ModelInstanceManager* model;
    if(name == "PanelData"){
        model = (ModelInstanceManager*) new PanelDataManager();
    } else if(name == "EnemyData"){
        model = (ModelInstanceManager*) new EnemyDataManager();
    } else if(name == "ItemMaster"){
        model = (ModelInstanceManager*) new ItemMasterManager();
    } else if(name == "EquipmentMaster"){
       model = (ModelInstanceManager*) new EquipmentMasterManager();
    } else if(name == "UserItem"){
        model = (ModelInstanceManager*) new UserItemManager();
    } else {
        model = (ModelInstanceManager*) new ModelInstanceManager();
    }
    this->append(model);
    return model;
}

ModelManager::ModelManager(){
    _modelMap = new map< string, ModelInstanceManager* >;
}

ModelManager* ModelManager::getInstance(){
    if(_instance == NULL){
        _instance = new ModelManager();
    }
    return _instance;
}

// ModelManager         -  modelA(modelAのinstanceの管理クラス) - 1 : record1(modelAのinstance)
// (model instanceの管理クラスの管理クラス)                         2 : record2(modelAのinstance)
//                      -  modelB(modelBのinstanceの管理クラス) - 1 : record1(modelBのinstance)
//                                                              2 : record2(modelBのinstance)

// modelManagerのobjectからgetModel("table名")->getById(1);
// modelManagerのオブジェクトがmodelのmapを持っていて
// modelがprimary keyで
