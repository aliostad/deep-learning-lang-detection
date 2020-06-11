//
//  World.cpp
//  Nanocraft
//
//  Created by Julien CAILLABET on 27/10/2014.
//  Copyright (c) 2014 Julien CAILLABET. All rights reserved.
//

#include "World.h"
#include "Engine.h"
#include "MathUtils.h"

World::World(int p, int q)
{
    this->p = p;
    this->q = q;
    
    /*push_back(new Chunk(p, q));
    Chunk* chunk = (*this)[this->size()-1];
    
    genChunkBuffer(chunk);*/
}

Chunk* World::getChunk(int p, int q)
{
    return 0;
}

void World::dirtyChunk(Chunk *chunk)
{
    chunk->dirty = 1;
    if (hasLights(chunk))
    {
        for (int dp = -1; dp <= 1; dp++)
        {
            for (int dq = -1; dq <= 1; dq++)
            {
                Chunk *other = findChunk(chunk->p + dp, chunk->q + dq);
                if (other)
                    other->dirty = 1;
            }
        }
    }
}

void World::genChunkBuffer(Chunk *chunk)
{
    chunk->compute();
    chunk->generate();
    chunk->empty();
    chunk->dirty = 0;
}

int World::hasLights(Chunk *chunk)
{
    if (!SHOW_LIGHTS)
        return 0;
    for (int dp = -1; dp <= 1; dp++)
    {
        for (int dq = -1; dq <= 1; dq++)
        {
            Chunk *other = chunk;
            if (dp || dq)
                other = findChunk(chunk->p + dp, chunk->q + dq);
            if (!other)
                continue;
            Map *map = other->lights;
            if (map->size)
                return 1;
        }
    }
    return 0;
}

Chunk *World::findChunk(int p, int q)
{
    for (int i = 0; i < size(); i++)
    {
        Chunk *chunk = (*this)[i];
        if (chunk->p == p && chunk->q == q)
            return chunk;
    }
    return 0;
}

Chunk *World::requestChunk(int &best_score, int &best_a, int &best_b)
{
    float planes[6][4];
    Chunk *chunk;

    Model* model = Engine::getInstance()->getModel();
    int r = model->create_radius;
    for (int dp = -r; dp <= r; dp++)
    {
        for (int dq = -r; dq <= r; dq++)
        {
            int a = p + dp;
            int b = q + dq;
            chunk = model->chunks->findChunk(a, b);
            if ( (chunk && !chunk->dirty) )
                continue;
            if( (chunk && chunk->busy) )
                continue;
            int distance = MAX(ABS(dp), ABS(dq));
            int invisible = !model->chunkVisible(planes, a, b, 0, 256);
            int priority = 0;
            if (chunk)
            {
                priority = chunk->buffer && chunk->dirty;
            }
            int score = (invisible << 24) | (priority << 16) | distance;
            if (score < best_score)
            {
                best_score = score;
                best_a = a;
                best_b = b;
            }
        }
    }
    if(chunk)
        chunk->busy = 1;
    return 0;
}