#ifndef __ANN_LOCATOR_H__
#define __ANN_LOCATOR_H__

#include "ANN/ANN.h"
#include "Locator.h"
#include "MeshPart.h"
#include "Points.h"

namespace cigma
{
    class AnnLocator;
}


class cigma::AnnLocator : public cigma::Locator
{
public:
    AnnLocator();
    ~AnnLocator();

public:
    void initialize(MeshPart *meshPart);
    void initialize(Points *points);

public:
    void search_bbox(double *point);
    void search_point(double *point);

public:
    int n_idx();
    int idx(int i);


public:
    int nnk;            // number of nearest neighbors
    int npts;           // number of points (bounding boxes)
    int ndim2;          // dimension of bounding box (ndim * 2)
    double epsilon;     // tolerance (in bbox space)

public:
    ANNpointArray dataPoints;
    ANNkd_tree *kdtree;

public:
    ANNpoint queryPoint;    // query point for search()
    ANNidxArray nnIdx;      // near neighbor indices
    ANNdistArray nnDists;   // near neighbor distances

public:

    typedef enum {
        NULL_LOCATOR,
        POINT_LOCATOR,
        CELL_LOCATOR
    } AnnLocatorType;

    AnnLocatorType locatorType;

};


// ---------------------------------------------------------------------------

inline int cigma::AnnLocator::n_idx()
{
    return nnk;
}

inline int cigma::AnnLocator::idx(int i)
{
    //assert(0 <= i);
    //assert(i < nnk);
    return nnIdx[i];
}


// ---------------------------------------------------------------------------

#endif
