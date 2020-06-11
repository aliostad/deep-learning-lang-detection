#ifndef __LOCATOR_H__
#define __LOCATOR_H__


namespace cigma
{
    class Locator;
    class MeshPart;
    class Points;
}


class cigma::Locator
{
public:
    Locator();
    virtual ~Locator();

public:
    // XXX: figure out a better scheme for initializing Locator instances
    virtual void initialize(MeshPart *meshPart) = 0;
    virtual void initialize(Points *points) = 0;

public:
    virtual void search_bbox(double *point) = 0;
    virtual void search_point(double *point) = 0;

public:
    virtual int n_idx() = 0;
    virtual int idx(int i) = 0;

public:
    int ndim;   // dimensions of point
};


#endif
