#ifndef CHUNK_DESERTLANDCHUNKGENERATOR_H
#define CHUNK_DESERTLANDCHUNKGENERATOR_H
#include <Chunk/ChunkGenerator.h>
namespace Chunk
{
    /**
      * Genère un chunk principalement composé de sables et de montagnes
      * @brief Genère un chunk principalement composé de sables et de montagnes
      * @author Sam101
      */
    class DesertLandChunkGenerator : public ChunkGenerator
    {
        public:
            /**
              * Genère un chunk
              * @param chunk Pointeur vers le chunk a générer (déjà alloué)
              */
            virtual void generate(Chunk *chunk);
    };
}
#endif //CHUNK_DESERTLANDCHUNKGENERATOR_H
