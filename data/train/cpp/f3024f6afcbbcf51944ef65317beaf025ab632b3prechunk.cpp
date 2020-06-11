#include "prechunk.hpp"

#include "../../stream.hpp"

namespace libminecraft {
namespace mainline {
namespace protocol {
namespace server {
namespace packet {
PreChunk::PreChunk() {

}

void PreChunk::read(std::istream & stream) {
    Stream::getInt(stream, x);
    Stream::getInt(stream, z);
    Stream::getBool(stream, load);
}

void PreChunk::write(std::ostream & stream) const {
    Stream::putInt(stream, x);
    Stream::putInt(stream, z);
    Stream::putBool(stream, load);
}

void PreChunk::toReadable(std::ostream & os) const {
    os << "X: " << x << "\n";
    os << "Z: " << z << "\n";
    os << "Load: " << load << std::endl;
}
}
}
}
}
}
