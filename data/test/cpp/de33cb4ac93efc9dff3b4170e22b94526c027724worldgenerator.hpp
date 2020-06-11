#ifndef BLOCKS_WORLDGENERATOR_H
#define BLOCKS_WORLDGENERATOR_H

#include <thread>
#include "queue.hpp"
#include "chunk.hpp"
#include "chunkgen.hpp"
#include "worldgen.hpp"

class WorldGenerator {
public:
    WorldGenerator(int num_threads);
    ~WorldGenerator();

    void generate(Chunk *chunk, ChunkGenerator *);
    void generate(Chunk *chunk, Chunk *chunkabove, Chunk *chunkbelow, WorldGen::GenFunc genfunc);
    void remesh(Chunk *chunk, Chunk *chunkabove, Chunk *chunkbelow, Chunk *chunknorth, Chunk *chunksouth, Chunk *chunkeast, Chunk *chunkwest, bool instant);

private:
    struct Message {
        enum Type {GENERATIONA, GENERATIONB,  REMESH, CLOSE_SIG} m_type;
        union {
            struct {
                Chunk *chunk;
                ChunkGenerator *generator;
            } generationa;
            struct {
                Chunk *chunk;
                Chunk *chunkabove;
                Chunk *chunkbelow;
                WorldGen::GenFunc genfunc;
            } generationb;
            struct {
                Chunk *chunk;
                Chunk *chunkabove;
                Chunk *chunkbelow;
                Chunk *chunknorth;
                Chunk *chunksouth;
                Chunk *chunkeast;
                Chunk *chunkwest;
            } remesh;
        } data;
    };

    void worker();

    void generationa_f(Message &m);
    void generationb_f(Message &m);
    void remesh_f(Message &m);

    TQueue<Message> queue;
    int num_threads;
    std::thread **threads;
};

#endif
