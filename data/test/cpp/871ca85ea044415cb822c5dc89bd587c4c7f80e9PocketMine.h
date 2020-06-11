
#include <rules/Binary.h>

#define COMPILE 1

#ifdef COMPILE_64
#define Level::chunkHash(chunkX, chunkZ) (((chunkX) & 0xFFFFFFFF) << 32) | ((chunkZ) & 0xFFFFFFFF)
#define Level::blockHash(x, y, z) (((x) & 0xFFFFFFF) << 35) | (((y) & 0x7f) << 28) | ((z) & 0xFFFFFFF)
#define Level::getXZ(hash, chunkX, chunkZ) chunkX = (hash >> 32) << 32 >> 32; chunkZ = (hash & 0xFFFFFFFF) << 32 >> 32;
#define Level::getBlockXYZ(hash, X, Y, Z) X = (hash >> 35) << 36 >> 36; Y = ((hash >> 28) & 0x7f); Z = (hash & 0xFFFFFFF) << 36 >> 36;
#else
#ifdef COMPILE_32
#define Level::chunkHash(chunkX, chunkZ) (chunkX) . ":" . (chunkZ)
#define Level::blockHash(x, y, z) (x) . ":" . (y) .":". (z)
#define Level::getXZ(hash, chunkX, chunkZ) list(chunkX, chunkZ) = explode(":", hash); chunkX = (int) chunkX; chunkZ = (int) chunkZ;
#define Level::getBlockXYZ(hash, X, Y, Z) list(X, Y, Z) = explode(":", hash); X = (int) X; Y = (int) Y; Z = (int) Z;
#else
#define Level::chunkHash(chunkX, chunkZ) (PHP_INT_SIZE === 8 ? (((chunkX) & 0xFFFFFFFF) << 32) | ((chunkZ) & 0xFFFFFFFF) : (chunkX) . ":" . (chunkZ))
#define Level::blockHash(x, y, z) (PHP_INT_SIZE === 8 ? (((x) & 0xFFFFFFF) << 35) | (((y) & 0x7f) << 28) | ((z) & 0xFFFFFFF) : (x) . ":" . (y) .":". (z))
#define Level::getXZ(hash, chunkX, chunkZ) if(PHP_INT_SIZE === 8){chunkX = (hash >> 32) << 32 >> 32; chunkZ = (hash & 0xFFFFFFFF) << 32 >> 32;}else{list(chunkX, chunkZ) = explode(":", hash); chunkX = (int) chunkX; chunkZ = (int) chunkZ;}
#define Level::getBlockXYZ(hash, X, Y, Z) if(PHP_INT_SIZE === 8){X = (hash >> 35) << 36 >> 36; Y = ((hash >> 28) & 0x7f); Z = (hash & 0xFFFFFFF) << 36 >> 36;}else{list(X, Y, Z) = explode(":", hash); X = (int) X; Y = (int) Y; Z = (int) Z;}
#endif
#endif
