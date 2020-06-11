// Copyright (c) 2014 Oliver Lau <ola@ct.de>, Heise Zeitschriften Verlag
// All rights reserved.

#ifndef __SAMPLE_H_
#define __SAMPLE_H_

#include <QVector>


class Sample {
public:
    Sample(void)
        : timestamp(0)
    { /* ... */ }
    Sample(const QPointF &p, qint64 t)
        : pos(p)
        , timestamp(t)
    { /* ... */ }
    Sample(const Sample& other)
        : pos(other.pos)
        , timestamp(other.timestamp)
    { /* ... */ }
    QPointF pos;
    qint64 timestamp;
};

typedef QVector<Sample> Samples;

#endif // __SAMPLE_H_
