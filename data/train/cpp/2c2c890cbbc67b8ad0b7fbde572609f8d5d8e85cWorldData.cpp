#include "WorldData.h"
#include "Chunk.h"
#include "Tile.h"

const Chunk& WorldData::getChunk( int x, int y ) const {
    return chunks[x + xOffset][ y + yOffset];
}

const Tile& WorldData::getTile( int x, int y ) const {
    const Chunk& chunk = getChunk( 
		    (int) floor( ((float) x) / CHUNK_SIDE ),
            (int) floor( ((float) y) / CHUNK_SIDE ) );
    return chunk.getAbsoluteTile(x, y);
}

const Tile& WorldData::getTile( sf::Vector2i in ) const {
    return getTile( in.x, in.y );
}

void WorldData::digTile( int x, int y, Player& player ) {
    int chunksX = (int) floor( ((float) x) / CHUNK_SIDE );
    int chunksY = (int) floor( ((float) y) / CHUNK_SIDE );
    chunks[chunksX + xOffset][ chunksY + yOffset]
            .digAbsoluteTile( x, y, player );
}

WorldData::WorldData(void) {
    xOffset = 10;
    yOffset = 10;
    for( int i = 0; i < 20; i++ ) {
        for( int j = 0; j < 10; j++ ) {
            chunks[i][j] = Chunk::Chunk( 
                    sf::Vector2i( ( i - xOffset ) * CHUNK_SIDE, 
                    ( j - yOffset ) * CHUNK_SIDE ), 2 ); // Dirt
            chunks[i][j+10] = Chunk::Chunk( 
                    sf::Vector2i( ( i - xOffset ) * CHUNK_SIDE, 
                    ( j + 10 - yOffset ) * CHUNK_SIDE ), 1 ); // Surface
        }
    }
}

WorldData::~WorldData(void) {
}
