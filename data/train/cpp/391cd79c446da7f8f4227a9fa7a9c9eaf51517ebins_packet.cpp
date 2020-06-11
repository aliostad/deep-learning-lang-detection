#include "ins_packet.h"

using namespace domain;

QDataStream& InsPacket::operator >>(QDataStream& stream) const
{
    stream << status;
    if (!status) return stream;

    stream << pitch;
    stream << roll;
    stream << yaw;

    return stream;
}

QDataStream& InsPacket::operator <<(QDataStream& stream)
{
    stream >> status;
    if (!status) return stream;

    stream >> pitch;
    stream >> roll;
    stream >> yaw;

    return stream;
}

InsPacket InsPacket::fromByteArray(const QByteArray& data)
{
    QDataStream stream(data);
    InsPacket packet;
    stream >> packet;
    return packet;
}
