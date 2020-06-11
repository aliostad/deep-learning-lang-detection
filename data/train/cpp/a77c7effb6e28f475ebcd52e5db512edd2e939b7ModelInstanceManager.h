//
//  ModelInstanceManager.h
//  model
//
//  Created by Kosuke Takami on 2013/10/20.
//  Copyright (c) 2013年 Kosuke Takami. All rights reserved.
//

#ifndef __model__ModelInstanceManager__
#define __model__ModelInstanceManager__

#include <iostream>
#include <map>
#include "Util.h"
#include "ModelInterface.h"
#include <sstream>

using namespace std;

// モデルインスタンス自体と管理クラス
class ModelInstanceManager{
private:
protected:
    std::string name;
    map<string, ModelInterface*> *_modelMap;
public:
    std::string getModelName();
    virtual void add(ModelInterface* model);
    virtual void remove(ModelInterface* model);
    virtual ModelInterface* getByPrimaryKey(int id);
    ModelInstanceManager();
    ~ModelInstanceManager();
};

#endif /* defined(__model__ModelInstanceManager__) */