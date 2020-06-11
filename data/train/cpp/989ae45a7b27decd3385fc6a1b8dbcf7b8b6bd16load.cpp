#include "load.h"


Load::Load(Beam *beam)
{
    this->beam = beam;
}

Load::Load(Beam *beam, double loadValue)
{
    this->beam = beam;
    applyUniformLoad(loadValue);
}


Load::Load(Beam *beam, double loadValue, double loadPosition)
{
    this->beam = beam;
    applySingleLoad(loadValue, loadPosition);
}

bool Load::applySingleLoad(double loadValue, double loadPosition)
{
    if(isProperLoadPosition(loadPosition)){
        setLoadOptionSingle();
        setLoadValue(loadValue);
        setLoadPosition(loadPosition);
        return true;
    }
    else
        return false;

}

void Load::applyUniformLoad(double loadValue)
{
    setLoadOptionUniform();
    setLoadValue(loadValue);
}

void Load::setLoadValue(double loadValue) {
    this->loadValue = loadValue;
}

double Load::getLoadValue() const {
    return this->loadValue;
}

bool Load::setLoadPosition(double loadPosition) {
    if(isProperLoadPosition(loadPosition)) {
        this->loadPosition = loadPosition;
        return true;
    }
    else
        return false;

}

double Load::getLoadPosition() const {
    return loadPosition;
}


bool Load::isProperLoadPosition(double position)
{
    if( (position < 0) || (position> beam->GetLength()) )
        return false;
    else
        return true;
}

void Load::setLoadOptionSingle()
{
    this->uniformLoad = false;
}

void Load::setLoadOptionUniform()
{
    this->uniformLoad = true;
}

bool Load::isSingleLoad() const
{
    return !(this->uniformLoad);
}

bool Load::isUniformLoad() const {
    return this->uniformLoad;
}

double Load::position2ratio(double position) {
    return (position)/(beam->GetLength());
}

double  Load::ratio2position(double ratio) {
    return ratio *beam->GetLength();
}


//bool Load::setLoadPositionRatio(double ratio)
//{
//    if (ratio < 0 || ratio > 100)
//        return false;

//    this->loadPosition = ratio * 0.01 *beam->GetLength();
//    return true;
//}

//double Load::getLoadPositionRatio() const
//{
//    return (this->loadPosition)/(beam->GetLength()) * 100;
//}
