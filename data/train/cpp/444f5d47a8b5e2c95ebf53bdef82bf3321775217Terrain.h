#ifndef MINECRAP_TERRAIN_H
#define MINECRAP_TERRAIN_H

#include "Chunk.h"

class Terrain
{
    public:
        virtual void generate(Chunk &chunk) = 0;
};


class RockyWorldTerrain : public Terrain
{
    public:
        void generate(Chunk &chunk);
};

class SimpleTerrain : public Terrain
{
    public:
        void generate(Chunk &chunk);

    private:
        void addDirt(Chunk &chunk);
        void addSand(Chunk &chunk);
        void addMarkersAtBoundaries(Chunk &chunk);
        void addBedrock(Chunk &chunk);
        void addWaterLevel(Chunk &chunk);
};

#endif
