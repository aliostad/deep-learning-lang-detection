#include "WorldChunk.h"

WorldChunk::WorldChunk():
    chunk_x(0), chunk_y(0), chunk_z(0)
{
    for( int x=0; x<CHUNK_SIZE; x++ )
    {
        for( int y=0; y<CHUNK_SIZE; y++ )
        {
            for( int z=0; z<CHUNK_SIZE; z++ )
            {
                this->data[x][y][z] = false;
                if( (x+z)/2 == y )
                    this->data[x][y][z] = true;
            }
        }
    }
}
WorldChunk::~WorldChunk()
{
}
void WorldChunk::render()
{
    for( int x=0; x<CHUNK_SIZE; x++ )
    {
        for( int y=0; y<CHUNK_SIZE; y++ )
        {
            for( int z=0; z<CHUNK_SIZE; z++ )
            {
                if( this->data[x][y][z] )
                {
                    renderCube(glm::vec3(this->chunk_x+x, this->chunk_y+y, this->chunk_z+z));
                }
            }
        }
    }
}
void WorldChunk::checkCollides(GameContext* context)
{
    glm::vec3 pos = context->camera_position;
    int x = -(int)pos.x;
    int y = -(int)pos.y-2;
    int z = -(int)pos.z;
    // printf("%d %d %d\n", x, y, z);
    //
    if( x >= CHUNK_SIZE || y >= CHUNK_SIZE || z >= CHUNK_SIZE )
        return;
    if( x < 0 || y < 0 || z < 0 )
        return;
    if( this->data[x][y][z] )
    {
        context->velocity.y = 0;
    }
}
