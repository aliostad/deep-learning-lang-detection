#ifndef CHUNK_ISLANDCHUNKGENERATOR_H
#define CHUNK_ISLANDCHUNKGENERATOR_H
#include <Chunk/ChunkGenerator.h>
namespace Chunk
{
    /**
      * Genère un chunk de type "Island:" Chunk contenant de la mer et une grande ile
      * @brief Genère un chunk de type "Island": Chunk contenant de la mer et une grande ile, ainsi que
      * quelques petites iles
      * @author Sam101
      */
    class IslandChunkGenerator : public ChunkGenerator
    {
        public:
        /**
          * Genère un chunk "island".
          * @param chunk Pointeur vers le chunk a générer (déjà alloué)
          */
        virtual void generate(Chunk *chunk);

    };
}
#endif //CHUNK_ISLANDCHUNKGENERATOR_H
