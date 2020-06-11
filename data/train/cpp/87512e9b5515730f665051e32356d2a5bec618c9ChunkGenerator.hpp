#ifndef MAP_CHUNKGENERATOR_HPP
#define MAP_CHUNKGENERATOR_HPP

#include "Map.hpp"
#include "Chunk.hpp"

namespace map
{

template <typename T>
class ChunkGenerator
{
    public:
        static void generate(Chunk<T,ChunkGenerator<T>>& chunk);

        static void setMap(Map<T,ChunkGenerator<T>>* map);

    private:
        static Map<T,ChunkGenerator<T>>* mMap;
};

template<typename T>
Map<T,ChunkGenerator<T>>* ChunkGenerator<T>::mMap = nullptr;

template <typename T>
void ChunkGenerator<T>::generate(Chunk<T,ChunkGenerator<T>>& chunk)
{
}

template <typename T>
void ChunkGenerator<T>::setMap(Map<T,ChunkGenerator<T>>* map)
{
    mMap = map;
}

} // namespace map

#endif // MAP_CHUNKGENERATOR_HPP
