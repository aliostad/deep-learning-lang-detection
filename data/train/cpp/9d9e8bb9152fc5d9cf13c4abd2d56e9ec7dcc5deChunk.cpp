#include "client/precompiled.hpp"

#include "client/map/Chunk.hpp"

#include "common/physics/Chunk.hpp"

namespace Client { namespace Map {

    Chunk::Chunk(IdType id)
        : Common::BaseChunk(id),
        _mesh(0),
        _physicsChunk(0)
    {
    }

    Chunk::Chunk(CoordsType const& c)
        : Common::BaseChunk(c),
        _mesh(0),
        _physicsChunk(0)
    {
    }

    Chunk::~Chunk()
    {
        Tools::Delete(this->_mesh);
        Tools::Delete(this->_physicsChunk);
    }

    void Chunk::SetMesh(std::unique_ptr<ChunkMesh> mesh)
    {
        Tools::Delete(this->_mesh);
        this->_mesh = mesh.release();
    }

    void Chunk::SetPhysics(std::unique_ptr<Common::Physics::Chunk> physics)
    {
        Tools::Delete(this->_physicsChunk);
        this->_physicsChunk = physics.release();
    }

}}
