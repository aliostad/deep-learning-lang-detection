//
//  LoadRes.h
//  TestGame
//
//  Created by lh on 13-11-13.
//  www.9miao.com
//

#ifndef __TestGame__LoadRes__
#define __TestGame__LoadRes__

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
using namespace cocos2d;
using namespace extension;

class LoadRes{
public:
    LoadRes();
    ~LoadRes();
    static LoadRes * shareLoadRes();
    void loadRolePersonTexture();
    void freeRolePersonTexture();
    void loadRolePersonTexture02();
    void freeRolePersonTexture02();
    void loadEnemyPersonTexture();
    void freeEnemyPersonTexture();
    void loadBossTexture();
    void freeBossTexture();
    
};
#endif /* defined(__TestGame__LoadRes__) */
