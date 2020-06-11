#ifndef LOAD_H
#define LOAD_H

#include "beam.h"


class Load
{

private:
    Beam *beam;
    double loadValue;
    double loadPosition;
    bool uniformLoad;

public:

    Load(Beam *beam);
    Load(Beam *beam, double loadValue);
    Load(Beam *beam, double loadValue, double loadPosition);
    //standard load options interfaces
    void applyUniformLoad(double loadValue);
    bool applySingleLoad(double loadValue, double loadPosition);

    //setters and getters
    void setLoadOptionUniform();
    void setLoadOptionSingle();
    bool isUniformLoad() const;
    bool isSingleLoad() const;

    void setLoadValue(double loadValue);
    double getLoadValue() const;

    bool setLoadPosition(double loadPosition);
    double getLoadPosition() const;

    double position2ratio(double position);
    double ratio2position(double ratio);

    bool isProperLoadPosition(double position);

};

#endif // LOAD_H
