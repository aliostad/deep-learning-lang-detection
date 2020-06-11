#include "direct_packet.h"

using namespace domain;

QDataStream& DirectPacket::operator >>(QDataStream& stream) const
{
    stream << isManual;

    if (isManual)
    {
        stream << manual;
    }
    else
    {
        stream << automatic;
    }

    return stream;
}

QDataStream& DirectPacket::operator <<(QDataStream& stream)
{
    stream >> isManual;

    if (isManual)
    {
        stream >> manual;
    }
    else
    {
        stream >> automatic;
    }

    return stream;
}

DirectPacket DirectPacket::fromByteArray(const QByteArray& data)
{
    QDataStream stream(data);
    DirectPacket packet;
    stream >> packet;
    return packet;
}
