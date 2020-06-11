#ifndef _HS_GameStateLoadPlugin_H_
#define _HS_GameStateLoadPlugin_H_
#pragma once

#include "system/GameState.h"

namespace hs {

class GameStateLoadPlugin : public GameState
{
public:
    GameStateLoadPlugin();
    virtual ~GameStateLoadPlugin();

    virtual bool enter();
    virtual void exit();

    virtual void tick(const float dTime);

private:

    //Disable default copy constructor and default assignment operator
    GameStateLoadPlugin(const GameStateLoadPlugin&);
    GameStateLoadPlugin& operator=(const GameStateLoadPlugin&);
};

} //end namespace

#endif
