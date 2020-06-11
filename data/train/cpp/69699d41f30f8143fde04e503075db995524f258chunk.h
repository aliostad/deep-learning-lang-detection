#ifndef CHUNK_H
#define CHUNK_H

#include <QtCore>
#include "../render/gfx_primitives.h"
#include "block.h"
#include "../render/texcoords_terrain.h"

const int CHUNK_SIZE_X = 16;
const int CHUNK_SIZE_Y = 128;
const int CHUNK_SIZE_Z = 16;

class Chunk
{
public:
    Chunk();
    ~Chunk();
    void randomGenerate(int count);
    void loadFromFile(QString filename);
    void saveToFile(QString filename);
    void updateArrays();
    void setChunkPosition(QPointF pos) {chunk_pos = pos; updateArrays();}
protected:
    QPointF chunk_pos;
    QVector<avVertex3> vertex_array;
    QVector<avTexCube> texcoord_array;
    QList<Block> blocks;
    int block[CHUNK_SIZE_X][CHUNK_SIZE_Y][CHUNK_SIZE_Z];  // index in list of
                                                          //  blocks, = -1 if NULL
    friend class Render;
};

#endif // CHUNK_H
