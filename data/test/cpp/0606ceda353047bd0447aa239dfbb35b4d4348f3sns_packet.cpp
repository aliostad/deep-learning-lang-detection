#include "sns_packet.h"

using namespace domain;

QDataStream& SnsPacket::operator >>(QDataStream& stream) const
{
    stream << status;
    if (!status) return stream;

    stream << fix;
    if (fix > 1)
    {
        stream << fix2d.latitude;
        stream << fix2d.longitude;
        stream << fix2d.groundSpeed;
        stream << fix2d.yaw;

        if (fix > 2)
        {
            stream << fix3d.altitude;
            stream << fix3d.climb;
        }
    }

    return stream;
}

QDataStream& SnsPacket::operator <<(QDataStream& stream)
{
    stream >> status;
    if (!status) return stream;

    stream >> fix;
    if (fix > 1)
    {
        stream >> fix2d.latitude;
        stream >> fix2d.longitude;
        stream >> fix2d.groundSpeed;
        stream >> fix2d.yaw;

        if (fix > 2)
        {
            stream >> fix3d.altitude;
            stream >> fix3d.climb;
        }
    }

    return stream;
}

SnsPacket SnsPacket::fromByteArray(const QByteArray& data)
{
    QDataStream stream(data);
    SnsPacket packet;
    stream >> packet;
    return packet;
}
