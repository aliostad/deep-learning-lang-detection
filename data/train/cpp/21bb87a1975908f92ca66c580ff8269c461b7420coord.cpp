#include "voxel_grid/coord.hpp"

namespace voxel_grid{
    
    template <typename tag>
    std::ostream& operator<<(std::ostream& os, const coord<tag>& coord){
      os << "(" << coord.x << ", " << coord.y << ", " << coord.z << ")";
      return os;
    }

    world_coord to_world_coord(const chunk_coord& chunk){
        return {
            chunk.x * chunk_size,
            chunk.y * chunk_size,
            chunk.z * chunk_size
        };
    }

    world_coord to_world_coord(const chunk_coord& chunk, const intra_chunk_coord& intra_chunk){
        return {
            (chunk.x * chunk_size) + intra_chunk.x,
            (chunk.y * chunk_size) + intra_chunk.y,
            (chunk.z * chunk_size) + intra_chunk.z
        };
    }

    std::pair<chunk_coord, intra_chunk_coord> from_world_coord(const world_coord& coord){
        auto to_chunk = [](const int v){
            if(v < 0){
                return (v + 1) / chunk_size - 1;
            } else {
                return v / chunk_size;
            }
        };
        auto to_intra = [](const int v){
            if(v < 0){
                return (v % chunk_size + chunk_size) % chunk_size;
            } else {
                return v % chunk_size;
            }
        };
        chunk_coord chunk{
            to_chunk(coord.x),
            to_chunk(coord.y),
            to_chunk(coord.z)
        };
        intra_chunk_coord intra{
            to_intra(coord.x),
            to_intra(coord.y),
            to_intra(coord.z)
        };
        return std::make_pair(chunk, intra);
    }
}