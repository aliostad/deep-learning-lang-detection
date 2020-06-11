/*
 * point.cpp
 *
 *  Created on: 08/mar/2012
 *      Author: Mladen Mazuran
 */

#include "point.h"
#include "slam/constants.h"

namespace SLAM {
namespace Geometry {

void Point::serializeTo(QDataStream &stream) const
{
    stream << xp << yp;
}

void Point::deserializeFrom(QDataStream &stream)
{
    stream >> xp >> yp;
}


LoggerStream &operator<<(LoggerStream &stream, const Point &point)
{
#ifdef FMT_MATHEMATICA
    return stream << "{" << point.x() << "," << point.y() << "}";
#else
    return stream << "(" << point.x() << "," << point.y() << ")";
#endif
}

LoggerStream &operator<<(LoggerStream &stream, const Point *point)
{
    return stream << *point;
}


} /* namespace Geometry */
} /* namespace SLAM */
