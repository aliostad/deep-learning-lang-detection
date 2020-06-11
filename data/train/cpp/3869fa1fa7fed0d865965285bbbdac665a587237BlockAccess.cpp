
#include "BlockAccess.hpp"
#include "Block.hpp"

namespace MCServer {

// BlockAccess<1>

namespace {

const int chunkHeight = 256; // For if I change chunks to be only 16 blocks.

}

BlockAccess<1>::BlockAccess(Chunk &chunk)
:chunk(chunk) {
}

BlockAccess<2> BlockAccess<1>::operator[](int x) {
    return BlockAccess<2>(chunk, x);
}

ConstBlockAccess<2> BlockAccess<1>::operator[](int x) const {
    return BlockAccess<2>(chunk, x);
}

BlockAccess<1>::operator ConstBlockAccess<1>() const {
    return ConstBlockAccess<1>(chunk);
}

BlockAccess<2>::BlockAccess(Chunk &chunk, int x)
:chunk(chunk), x(x) {
}

BlockAccess<3> BlockAccess<2>::operator[](int z) {
    return BlockAccess<3>(chunk, x, z);
}

ConstBlockAccess<3> BlockAccess<2>::operator[](int z) const {
    return ConstBlockAccess<3>(chunk, x, z);
}

BlockAccess<2>::operator ConstBlockAccess<2>() const {
    return ConstBlockAccess<2>(chunk, x);
}

BlockAccess<3>::BlockAccess(Chunk &chunk, int x, int z)
:chunk(chunk), x(x), z(z) {
}

Block BlockAccess<3>::operator[](int y) {
    return Block(chunk, x, y, z);
}

const Block BlockAccess<3>::operator[](int y) const {
    return Block(chunk, x, y, z);
}

BlockAccess<3>::operator ConstBlockAccess<3>() const {
    return ConstBlockAccess<3>(chunk, x, z);
}


ConstBlockAccess<1>::ConstBlockAccess(const Chunk &chunk)
:chunk(chunk) {
}

ConstBlockAccess<2> ConstBlockAccess<1>::operator[](int x) const {
    return ConstBlockAccess<2>(chunk, x);
}

ConstBlockAccess<2>::ConstBlockAccess(const Chunk &chunk, int x)
:chunk(chunk), x(x) {
}

ConstBlockAccess<3> ConstBlockAccess<2>::operator[](int z) const {
    return ConstBlockAccess<3>(chunk, x, z);
}

ConstBlockAccess<3>::ConstBlockAccess(const Chunk &chunk, int x, int z)
:chunk(chunk), x(x), z(z) {
}

const Block ConstBlockAccess<3>::operator[](int y) const {
    return Block(const_cast<Chunk &>(chunk), x, y, z);
}


}
