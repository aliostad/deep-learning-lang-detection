#ifndef _GEOMETRIC_MODEL_H
#define _GEOMETRIC_MODEL_H

#include "render/resource/model/rawModel.h"

class GeometricModel
{
public:

    // Geometric model IDs
    static int CUBE;
    static int SQUARE_XZ;

    // Get specific geometric model
    static RawModel* getGeometricModel(int modelId);

    // Clean up the models
    static void cleanUp();

private:

    // Geometric models
    static RawModel* cubeModel;
    static RawModel* squareXzModel;

    // Generate a cube model
    static RawModel* createCube();

    // Generate a square on the XZ plane
    static RawModel* createSquareXz();
};

#endif
