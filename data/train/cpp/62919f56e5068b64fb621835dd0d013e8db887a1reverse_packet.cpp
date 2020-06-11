#include "reverse_packet.h"

using namespace domain;

QDataStream& ReversePacket::operator >>(QDataStream& stream) const
{
    stream << altAvalible;
    if (altAvalible) stream << alt;

    stream << insAvalible;
    if (insAvalible) stream << ins;

    stream << snsAvalible;
    if (snsAvalible) stream << sns;

    return stream;
}

QDataStream& ReversePacket::operator <<(QDataStream& stream)
{
    stream >> altAvalible;
    if (altAvalible) stream >> alt;

    stream >> insAvalible;
    if (insAvalible) stream >> ins;

    stream >> snsAvalible;
    if (snsAvalible) stream >> sns;

    return stream;
}

ReversePacket ReversePacket::fromByteArray(const QByteArray& data)
{
    QDataStream stream(data);
    ReversePacket packet;
    stream >> packet;
    return packet;
}
