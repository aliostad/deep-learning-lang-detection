#ifndef __CLIENT_MAP_CHUNK_HPP__
#define __CLIENT_MAP_CHUNK_HPP__

#include "common/BaseChunk.hpp"
#include "client/map/ChunkMesh.hpp"

namespace Common { namespace Physics {
    class Chunk;
}}

namespace Client { namespace Map {
    class Map;
}}

class btRigidBody;

namespace Client { namespace Map {

    class Chunk
        : public Common::BaseChunk,
        private boost::noncopyable
    {
    private:
        ChunkMesh* _mesh;
        Common::Physics::Chunk* _physicsChunk;

    public:
        explicit Chunk(IdType id);
        explicit Chunk(CoordsType const& c);
        ~Chunk();

        ChunkMesh* GetMesh() { return this->_mesh; }
        void SetMesh(std::unique_ptr<ChunkMesh> mesh);

        Common::Physics::Chunk* GetPhysics() { return this->_physicsChunk; }
        void SetPhysics(std::unique_ptr<Common::Physics::Chunk> physics);
    };

}}

#endif
