#ifndef CHUNK_CHUNKGENERATOR_H
#define CHUNK_CHUNKGENERATOR_H
#include <Chunk/Chunk.h>
namespace Chunk
{
    /**
      * Classe abstraite de base pour les classes générant un
      * chunk
      * @brief Classe abstraite pour la génération de chunk
      * @author Sam101
      */
    class ChunkGenerator
    {
        public:
            /**
              * Genère un chunk
              * @param chunk Pointeur vers le chunk a générer (déjà alloué)
              */
            virtual void generate(Chunk *chunk) = 0;
            /**
              * Genère une ile carré
              */
            void genSquareIsland(Chunk *chunk, int xStart, int xEnd, int yStart, int yEnd);
    };
}
#endif //CHUNK_CHUNKGENERATOR_H
