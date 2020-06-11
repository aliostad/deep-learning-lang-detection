#include "playerposdir.hpp"

#include "../stream.hpp"

namespace libminecraft {
namespace mainline {
namespace protocol {
namespace packet {
void PlayerPosDir::read(std::istream & stream) {
    Stream::getDouble(stream, x);
    Stream::getDouble(stream, y);
    Stream::getDouble(stream, stance);
    Stream::getDouble(stream, z);
    Stream::getFloat(stream, yaw);
    Stream::getFloat(stream, pitch);
    Stream::getBool(stream, on_ground);
}

void PlayerPosDir::write(std::ostream & stream) const {
    Stream::putDouble(stream, x);
    Stream::putDouble(stream, y);
    Stream::putDouble(stream, stance);
    Stream::putDouble(stream, z);
    Stream::putFloat(stream, yaw);
    Stream::putFloat(stream, pitch);
    Stream::putBool(stream, on_ground);
}

void PlayerPosDir::toReadable(std::ostream & os) const {
    os << "X: " << x << "\n";
    os << "Y: " << y << "\n";
    os << "Z: " << z << "\n";
    os << "Stance: " << stance << "\n";
    os << "Yaw: " << yaw << "\n";
    os << "Pitch: " << pitch << "\n";
    os << "On Ground: " << on_ground << "\n";
}
}
}
}
}
