//
//  EvilInvoke.h
//  Boids
//
//  Created by chenyanjie on 6/11/15.
//
//

#ifndef __Boids__EvilInvoke__
#define __Boids__EvilInvoke__

#include "SkillNode.h"

class EvilInvoke : public SkillNode {
private:
    int _count;
    int _level;
    float _radius;
    float _duration;
    
public:
    EvilInvoke();
    virtual ~EvilInvoke();
    
    static EvilInvoke* create( UnitNode* owner, const cocos2d::ValueMap& data, const cocos2d::ValueMap& params );
    virtual bool init( UnitNode* owner, const cocos2d::ValueMap& data, const cocos2d::ValueMap& params );
    
    virtual void updateFrame( float delta );
    
    virtual void begin();
    virtual void end();
};

#endif /* defined(__Boids__EvilInvoke__) */
