#ifndef _HS_GameStateLoad_H_
#define _HS_GameStateLoad_H_
#pragma once

#include "system/GameState.h"

namespace hs {

class GameStateLoad : public GameState
{
public:
    GameStateLoad();
    virtual ~GameStateLoad();

    virtual bool enter();
    virtual void exit();

    virtual void tick(const float dTime);

private:

    //Disable default copy constructor and default assignment operator
    GameStateLoad(const GameStateLoad&);
    GameStateLoad& operator=(const GameStateLoad&);
};

} //end namespace

#endif
