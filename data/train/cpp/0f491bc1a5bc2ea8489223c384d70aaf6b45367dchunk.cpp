#include "game.hpp"

const unsigned char C_Game::GetCubeType(const int h, const int i, const int j)
{
    int diffX = 0;
    int diffY = 0;
    if(h < 0) diffX = 1;
    if(i < 0) diffY = 1;

    int a = (h+diffX)/CHUNK_SIZE;
    if(h < 0)
        a--;
    int b = (i+diffY)/CHUNK_SIZE;
    if(i < 0)
        b--;

    MinecraftChunk *ch = GetChunk(a, b);

    int xx = h + diffX - (int)((h+diffX)/CHUNK_SIZE) * CHUNK_SIZE;
    if(h < 0)
    {
        if(xx <= 0)
                xx = CHUNK_SIZE - 1 + xx;
    }

    int yy = i + diffY - (int)((i+diffY)/CHUNK_SIZE) * CHUNK_SIZE;
    if(i < 0)
    {
        if(yy <= 0)
                yy = CHUNK_SIZE - 1 + yy;
    }

    return ch->_chunkMap[xx][yy][j];
}

void C_Game::CheckChunksCubesVisibility(const int x, const int y)
{
    MinecraftChunk *ch = GetChunk(x, y);
    if(ch == NULL)
        return;

    if(!ch->_hidden)
        return;

    unsigned char tab[CHUNK_SIZE+2][CHUNK_SIZE+2][CHUNK_ZVALUE+2];
    for(int h=0;h<CHUNK_SIZE+2;h++)
        for(int i=0;i<CHUNK_SIZE+2;i++)
            for(int j=0;j<CHUNK_ZVALUE+2;j++)
                tab[h][i][j] = CUBE_DIRT;
    for(int h=0;h<CHUNK_SIZE;h++)
        for(int i=0;i<CHUNK_SIZE;i++)
            for(int j=0;j<CHUNK_ZVALUE;j++)
                tab[1+h][1+i][1+j] = ch->_chunkMap[h][i][j];

    for(int h=1;h<CHUNK_SIZE+1;h++)
    {
        for(int i=1;i<CHUNK_SIZE+1;i++)
        {
            for(int j=1;j<CHUNK_ZVALUE+1;j++)
            {
                if(tab[h][i][j] != CUBE_AIR)
                {
                    if( (h-1 >= 0 && tab[h-1][i][j] == CUBE_AIR) || ( h+1 < CHUNK_SIZE && tab[h+1][i][j] == CUBE_AIR)
                    || ( i-1 >= 0 && tab[h][i-1][j] == CUBE_AIR) || ( i+1 < CHUNK_SIZE && tab[h][i+1][j] == CUBE_AIR)
                    || ( j-1 >= 0 && tab[h][i][j-1] == CUBE_AIR) || ( j+1 < CHUNK_ZVALUE && tab[h][i][j+1] == CUBE_AIR) )
                    {
                        tabCube temp;
                        temp.x = h-1 + x*CHUNK_SIZE;
                        temp.y = i-1 + y * CHUNK_SIZE;
                        temp.z = j-1;
                        _tabCube[tab[h][i][j]].push_back(temp);
                    }

                }
            }
        }
    }
    ch->_hidden = false;
}

void C_Game::CreateRandomChunk(const int a, const int b)
{
    if(GetChunk(a, b) != NULL)
        return;

    MinecraftChunk *temp = new MinecraftChunk;
    temp->x = a;
    temp->y = b;
    temp->_hidden = true;
    _chunks.push_back(temp);

    for(int h=0;h<CHUNK_SIZE;h++)
    {
        for(int i=0;i<CHUNK_SIZE;i++)
        {
            for(int j=0;j<CHUNK_ZVALUE;j++)
            {
                _chunks.back()->_chunkMap[h][i][j] = (rand() % (NB_TYPE_CUBE-1)) +1;
            }
        }
    }
    for(int h=0;h<CHUNK_SIZE;h++)
        for(int i=0;i<CHUNK_SIZE;i++)
            for(int j=CHUNK_ZVALUE/2;j<CHUNK_ZVALUE;j++)
                _chunks.back()->_chunkMap[h][i][j] = CUBE_AIR;
}

MinecraftChunk* C_Game::GetChunk(const int x, const int y)
{
    for(unsigned int i=0;i<_chunks.size();i++)
        if(_chunks[i]->x == x && _chunks[i]->y == y)
            return _chunks[i];

    return NULL;
}

void C_Game::DeleteChunkFromMemory(const int x, const int y)
{
    MinecraftChunk *ch = GetChunk(x, y);
    if(ch == NULL)
        return;

    unsigned char tab[CHUNK_SIZE+2][CHUNK_SIZE+2][CHUNK_ZVALUE+2];
    for(int h=0;h<CHUNK_SIZE+2;h++)
        for(int i=0;i<CHUNK_SIZE+2;i++)
            for(int j=0;j<CHUNK_ZVALUE+2;j++)
                tab[h][i][j] = CUBE_DIRT;
    for(int h=0;h<CHUNK_SIZE;h++)
        for(int i=0;i<CHUNK_SIZE;i++)
            for(int j=0;j<CHUNK_ZVALUE;j++)
                tab[1+h][1+i][1+j] = ch->_chunkMap[h][i][j];

    for(int h=1;h<CHUNK_SIZE+1;h++)
    {
        for(int i=1;i<CHUNK_SIZE+1;i++)
        {
            for(int j=1;j<CHUNK_ZVALUE+1;j++)
            {
                if(tab[h][i][j] != CUBE_AIR)
                {
                    if( (h-1 >= 0 && tab[h-1][i][j] == CUBE_AIR) || ( h+1 < CHUNK_SIZE && tab[h+1][i][j] == CUBE_AIR)
                    || ( i-1 >= 0 && tab[h][i-1][j] == CUBE_AIR) || ( i+1 < CHUNK_SIZE && tab[h][i+1][j] == CUBE_AIR)
                    || ( j-1 >= 0 && tab[h][i][j-1] == CUBE_AIR) || ( j+1 < CHUNK_ZVALUE && tab[h][i][j+1] == CUBE_AIR) )
                    {
                        DeleteCubeOfVector(tab[h][i][j], (h-1 + x*CHUNK_SIZE), (i-1 + y * CHUNK_SIZE), j-1);
                    }

                }
            }
        }
    }

    SaveChunk(x, y);

    for(unsigned int i=0;i<_chunks.size();i++)
        if(_chunks[i]->x == x && _chunks[i]->y == y)
            _chunks.erase(_chunks.begin()+i);

    delete ch;
}
