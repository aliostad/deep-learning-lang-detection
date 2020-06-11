#ifndef SAMPLE_H
#define SAMPLE_H

#include <string.h>
#include <QFile>
#include <qstring.h>

class sample
{
public:
    sample();
    void setAttribute(int row, int beat, int att);

    int getAttribute(int row, int beat);
    int attributes[17][17];
    void setFile(int sampleNo, const char* location);

    QFile sampleLocation1;
    QFile sampleLocation2;
    QFile sampleLocation3;
    QFile sampleLocation4;
    QFile sampleLocation5;
    QFile sampleLocation6;
    QFile sampleLocation7;
    QFile sampleLocation8;
    QFile sampleLocation9;
    QFile sampleLocation10;
    QFile sampleLocation11;
    QFile sampleLocation12;
    QFile sampleLocation13;
    QFile sampleLocation14;
    QFile sampleLocation15;
    QFile sampleLocation16;
private:


};

#endif // SAMPLE_H
