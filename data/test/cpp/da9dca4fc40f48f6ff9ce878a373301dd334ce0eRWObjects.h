#ifndef RWOBJECTS_H
#define RWOBJECTS_H

#include <QDataStream>
#include "Primitives.h"

QDataStream & operator<< (QDataStream &out, const Sphere &sphere);
QDataStream & operator<< (QDataStream &out, const Triangle &tr);
QDataStream & operator<< (QDataStream &out, const float3 &a);
QDataStream & operator<< (QDataStream &out, const Material &material);
QDataStream & operator<< (QDataStream &out, const Light &light);


QDataStream & operator>> (QDataStream &in, const Sphere &sphere);
QDataStream & operator>> (QDataStream &in, const Triangle &tr);
QDataStream & operator>> (QDataStream &in, const float3 &a);
QDataStream & operator>> (QDataStream &in, const Material &material);
QDataStream & operator>> (QDataStream &in, const Light &light);

#endif // RWOBJECTS_H
