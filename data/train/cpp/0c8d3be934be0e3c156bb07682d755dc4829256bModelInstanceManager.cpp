//  ModelInstanceManager.cpp
//  model
//
//  Created by Kosuke Takami on 2013/10/20.
//  Copyright (c) 2013年 Kosuke Takami. All rights reserved.
//

#include "ModelInstanceManager.h"

ModelInstanceManager::ModelInstanceManager(){
    name = "ModelInstanceManager";
    _modelMap = new map<string, ModelInterface*>();
}

ModelInstanceManager::~ModelInstanceManager(){
}

std::string ModelInstanceManager::getModelName(){
    return name;
}

void ModelInstanceManager::add(ModelInterface* model){
    std::string key = Util::Util::intToString(model->getId());
    (*_modelMap)[key] = model;
}

void ModelInstanceManager::remove(ModelInterface* model){
    std::string key = Util::Util::intToString(model->getId());
    (*_modelMap)[key] = NULL;
}

ModelInterface* ModelInstanceManager::getByPrimaryKey(int id){
    std::string key = Util::Util::intToString(id);
    return (*_modelMap)[key];
}
