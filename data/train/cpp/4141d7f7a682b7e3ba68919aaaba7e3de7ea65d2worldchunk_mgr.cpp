#include "worldchunk_mgr.hpp"
#include "game/worldentity_handleconnection.hpp"
#include "game/worldgrid.hpp"

namespace clover {
namespace game {

WorldChunkMgr::ChunkSet WorldChunkMgr::getChunksInRadius(util::Vec2d p, real64 r){
	ChunkSet c;
	
	p -= util::Vec2d(game::WorldChunk::width*0.5);
	// 0.8 is a magic multiplier to produce visually somewhat correct results
	r += game::WorldChunk::width*0.8;

	for (auto it=chunks.begin(); it!= chunks.end(); ++it){
		game::WorldChunk& chunk= it->second;

		util::Vec2d chunkpos{(real64)chunk.getPosition().x, (real64)chunk.getPosition().y};
		chunkpos = chunkpos*game::WorldChunk::width;

		if ( util::Vec2d(chunkpos - p).lengthSqr() <= r*r){
			c.insert(&chunk);
		}
	}

	return c;
}

WorldChunkMgr::ChunkSet WorldChunkMgr::getChunksOutRadius(util::Vec2d p, real64 r){
	ChunkSet c;

	p -= util::Vec2d(game::WorldChunk::width*0.5);
	r += game::WorldChunk::width*0.8;

	for (auto it=chunks.begin(); it!= chunks.end(); ++it){
		game::WorldChunk& chunk= it->second;

		util::Vec2d chunkpos{	(real64)chunk.getPosition().x,
						(real64)chunk.getPosition().y };
		chunkpos = chunkpos*game::WorldChunk::width;

		if ( util::Vec2d(chunkpos - p).lengthSqr() > r*r){
			c.insert(&chunk);
		}
	}

	return c;
}

WorldChunkMgr::ChunkSet WorldChunkMgr::inhabitChunksInRadius(util::Vec2d p, real64 r){
	ChunkSet vec;

	r += game::WorldChunk::width*0.8;

	util::Vec2i search_pos= game::WorldGrid::worldToChunkVec(p - util::Vec2d(r));
	util::Vec2i start_pos= search_pos;
	util::Vec2i last_pos= game::WorldGrid::worldToChunkVec(p + util::Vec2d(r));

	// Search area of rectangle
	while (search_pos.y <= last_pos.y){
		if (p.distanceSqr(util::Vec2d{(real64)search_pos.x, (real64)search_pos.y}*game::WorldChunk::width) <= r*r){
			// 'p' is inside radius
			game::GridPoint p;
			p.setChunkVec(search_pos);
			if (!getChunk(p)){
				// No chunk with position 'p', create new
				vec.insert(&createChunk(p));
			}
		}

		++search_pos.x;
		if (search_pos.x > last_pos.x){
			search_pos.x=start_pos.x;
			++search_pos.y;
		}
	}

	return vec;
}

util::Set<RegionVec> WorldChunkMgr::getInhabitedRegionPositions() const {
	util::Set<RegionVec> regions;
	for (const auto& pair : chunks){
		regions.insert(game::GridPoint::Chunk(pair.first).getRegionVec());
	}
	return regions;
}

game::WorldChunk* WorldChunkMgr::getChunk(game::GridPoint p){

	auto it= chunks.find(p.getChunkVec());
	if (it == chunks.end()) return nullptr;

	return &it->second;

}

game::WorldChunk& WorldChunkMgr::createChunk(game::GridPoint pos){
	util::Vec2i p= pos.getChunkVec();
	
	game::WorldChunk *sides[4]={0,0,0,0};

	if (chunks.count(p)){
		throw global::Exception("WorldChunkManifold::createChunk(..): there's already chunk in position %i, %i", p.x, p.y);
	}

	for (auto it=chunks.begin(); it!=chunks.end(); ++it){
		game::WorldChunk &chunk= it->second;

		if (p.x + 1 == chunk.getPosition().x && p.y == chunk.getPosition().y) sides[game::WorldChunk::Right]= &chunk;
		if (p.x - 1 == chunk.getPosition().x && p.y == chunk.getPosition().y) sides[game::WorldChunk::Left]= &chunk;
		if (p.x == chunk.getPosition().x && p.y + 1 == chunk.getPosition().y) sides[game::WorldChunk::Up]= &chunk;
		if (p.x == chunk.getPosition().x && p.y - 1 == chunk.getPosition().y) sides[game::WorldChunk::Down]= &chunk;
	}

	game::WorldChunk& chunk= chunks[p];
	chunk.setPosition(p);

	for (int32 i=0; i<4; i++){
		if (sides[i]){
			chunk.setSide(*sides[i]);
		}
	}

	return chunk;
}

WorldChunkMgr::ChunkSet WorldChunkMgr::getChunks(){
	util::Set<game::WorldChunk*> vec;
	for (auto it= chunks.begin(); it != chunks.end(); ++it)
		vec.insert(&it->second);
	return vec;
}

WorldChunkMgr::ClusterSet WorldChunkMgr::getCommonClusters(ChunkSet chs) const {
	ClusterSet clusters;
	
	// Find all clusters in which chunks in 'chunks' belong
	for (const auto& chunk : chs){
		clusters.insert(chunk->getCluster());
	}
	
	// Remove clusters that are not fully inside the set of 'chunks'
	for (auto it= clusters.begin(); it != clusters.end();){
		if (!util::fullyContains(chs, *it))
			it= clusters.erase(it);
		else
			++it;
	}
	
	return clusters;
}

WorldChunkMgr::ClusterSet WorldChunkMgr::getClusters() const {
	ClusterSet clusters;
	for (const auto& pair : chunks){
		clusters.insert(pair.second.getCluster());
	}
	return clusters;
}

void WorldChunkMgr::updateChunkDependencies(){
	// Remove old dependencies
	for (auto it=chunks.begin(); it!=chunks.end(); ++it){
		if (it->second.getState() == game::WorldChunk::State::Active)
			it->second.clearDependencies();
	}

	// Record new dependencies
	for (auto it= StrictHandleConnection::begin(); it!= StrictHandleConnection::end(); ++it){
		StrictHandleConnection *con= *it;
		if (con == 0)
			continue;

		game::WeHandle& h= con->getHandle();

		game::WorldEntity *we1= h.get();
		game::WorldEntity *we2= &con->getOwner();

		if (!we1 || !we2)
			continue;

		game::WorldChunk *chunk1= we1->getInChunk();
		game::WorldChunk *chunk2= we2->getInChunk();

		if (!chunk1 || !chunk2 || chunk1 == chunk2)
			continue;

		if (chunk1->getState() != game::WorldChunk::State::Active || chunk2->getState() != game::WorldChunk::State::Active)
			continue;

		chunk1->addDependency(*chunk2);
		chunk2->addDependency(*chunk1);
	}
}

void WorldChunkMgr::startDestroyingChunk(game::WorldChunk& c){
	c.setState(game::WorldChunk::State::Destroying);
}

void WorldChunkMgr::startDestroyingChunks(const ChunkSet& c){
	for (auto& m : c){
		m->setState(game::WorldChunk::State::Destroying);
	}
}

void WorldChunkMgr::updateDestroying(){
	const SizeType remove_count= 10;
	SizeType removed= 0;

	for (auto& chunk_pair : chunks){
		game::WorldChunk& chunk= chunk_pair.second;
		if (chunk.getState() == game::WorldChunk::State::Destroying){
			removed += chunk.updateDestroying(remove_count - removed);

			ensure(removed <= remove_count);

			if (chunk.getEntityCount() == 0){
				destroyChunk(chunk);
				return;
			}

			if (removed == remove_count);
				return;
		}
	}
}

void WorldChunkMgr::destroyChunk(game::WorldChunk& c){
	auto it= chunks.find(c.getPosition());
	if (it != chunks.end()){

		// Remove dependencies to this chunk
		for (auto it2= chunks.begin(); it2!=chunks.end(); ++it2){
			it2->second.removeDependency(it->second);
		}

		chunks.erase(it);
	}
}

void WorldChunkMgr::destroyChunks(const ChunkSet& c){
	for (auto it=c.begin(); it!=c.end(); ++it){
		destroyChunk(**it);
	}
}

void WorldChunkMgr::removeAll(){
	chunks.clear();
}

} // game
} // clover