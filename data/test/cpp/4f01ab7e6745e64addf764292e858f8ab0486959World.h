//
//  World.h
//  Nanocraft
//
//  Created by Julien CAILLABET on 27/10/2014.
//  Copyright (c) 2014 Julien CAILLABET. All rights reserved.
//

#ifndef __Nanocraft__World__
#define __Nanocraft__World__

#include <stdio.h>
#include <vector>

#include "Chunk.h"

using namespace std;

class World : public vector<Chunk*>
{
    public:
        World(int p, int q);
        int p;
        int q;
        Chunk* getChunk(int p, int q);
        void dirtyChunk(Chunk *chunk);
        void genChunkBuffer(Chunk *chunk);
        Chunk *findChunk(int p, int q);
        Chunk *requestChunk(int &best_score, int &best_a, int &best_b);
        int hasLights(Chunk *chunk);
};

#endif /* defined(__Nanocraft__World__) */
