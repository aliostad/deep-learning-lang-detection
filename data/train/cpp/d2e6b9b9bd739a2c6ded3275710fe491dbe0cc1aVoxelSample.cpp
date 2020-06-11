#include "stdafx.h"
#include "VoxelSample.h"

namespace ettention
{
    VoxelSample::VoxelSample()
    {
    }

    VoxelSample::VoxelSample(Vec3f positionOffset, float rayDistanceInsideVoxel)
        : positionOffset(positionOffset)
        , rayDistanceInsideVoxel(rayDistanceInsideVoxel)
    {

    }

    VoxelSample::~VoxelSample()
    {

    }

    Vec3f VoxelSample::PositionOffset() const
    {
        return positionOffset;
    }

    float VoxelSample::RayDistanceInsideVoxel() const
    {
        return rayDistanceInsideVoxel;
    }
}