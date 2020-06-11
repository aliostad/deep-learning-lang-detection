//
//  InvokeLater.cpp
//  ccHelp_ios_mac
//
//  Created by Vinova on 7/21/15.
//  Copyright (c) 2015 Less. All rights reserved.
//

#include "InvokeLater.h"

namespace ccHelp
{
    InvokeLater::InvokeLater()
    : _clearDirty(false)
    {
        
    }
    
    InvokeLater* InvokeLater::_instance = nullptr;
    
    InvokeLater* InvokeLater::getInstance()
    {
        if (_instance == nullptr)
        {
            _instance = new InvokeLater();
            cocos2d::Director::getInstance()->getScheduler()->schedule([=](float dt) {
                _instance->doJobs(dt);
            }, _instance, 0, false, "InvokeLaterScheduleBackground");
        }
        
        return _instance;
    }
    
    void InvokeLater::doJobs(float dt)
    {
        if (this->checkClear())
            return;
        
        while (!Jobs.empty())
        {
            if (this->checkClear())
                return;
            
            auto job = Jobs.front();
            Jobs.pop_front();
            
            job.func();
        }
        
        if (this->checkClear())
            return;
        
        for (size_t i = 0; i < LazyJobs.size();)
        {
            if (this->checkClear())
                return;
            
            auto &job = LazyJobs[i];
            
            job.time -= dt;
            if (job.time <= 0)
            {
                job.job.func();
                LazyJobs.erase(LazyJobs.begin() + i);
                continue;
            }
            
            ++i;
        }
        
        this->checkClear();
    }
    
    void InvokeLater::invoke(std::function<void()> func)
    {
        Jobs.push_back(Job(func));
    }
    
    void InvokeLater::invoke(std::function<void()> func, float time)
    {
        LazyJobs.push_back({Job(func), time});
    }
    
    void InvokeLater::clear()
    {
        _clearDirty = true;
    }
    
    bool InvokeLater::checkClear()
    {
        if (_clearDirty)
        {
            Jobs.clear();
            LazyJobs.clear();
            _clearDirty = false;
            return true;
        }
        
        return false;
    }
}