//
//  ModuleLocator.h
//  DiverDark
//
//  Created by S_Wyvern on 2014/08/23.
//
//

#ifndef __DiverDark__ModuleLocator__
#define __DiverDark__ModuleLocator__

#include <iostream>
#include <map>

#include "BaseModule.h"

class ModuleLocator
{
public:
    static ModuleLocator* getInstance() {
        if (instance == NULL) {
            instance = new ModuleLocator();
        }
        return instance;
    }
    
    void registerModule(std::string key, BaseModule* module);
    
    template<typename T>
    inline T getModule(std::string key) {
        auto ret = modules.find(key);
        return dynamic_cast<T>(ret->second);
    }
    
private:
    static ModuleLocator* instance;
    
    std::map<std::string, BaseModule*> modules;
};

#endif /* defined(__DiverDark__ModuleLocator__) */
