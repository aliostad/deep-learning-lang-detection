#include "DiskSampleDistributor.h"

DiskSampleDistributor::DiskSampleDistributor()
{
    //ctor
}

DiskSampleDistributor::~DiskSampleDistributor()
{
    //dtor
}
Vector2Bf DiskSampleDistributor::mapSample(Vector2Bf sample)
{
    sample.x=sample.x*2-1;
    sample.y=sample.y*2-1;
    d_type::Bfloat r,phi;

    if(sample.x>-sample.y)
    {
        if(sample.x>sample.y)
        {
            r=sample.x;
            phi=sample.y/sample.x;
        }
        else
        {
            r=sample.y;
            phi=2-sample.x/sample.y;
        }
    }
    else
    {

        if(sample.x<sample.y)
        {
            r=-sample.x;
            phi=4+sample.y/sample.x;
        }
        else
        {
            r=-sample.y;
            phi=6-sample.x/sample.y;
        }
    }

    if(sample.x == 0 && sample.y == 0)
    {
        phi=0;
    }

    phi*=M_PI/4;
    return Vector2Bf(r*cosf(phi),r*sinf(phi));
}
