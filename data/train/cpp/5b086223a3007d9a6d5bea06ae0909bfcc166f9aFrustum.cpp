
#include "Frustum.h"

namespace three {

  Frustum::Frustum()
  {
  }

  Frustum::Frustum(Matrix4 const& modelViewProjection)
  {
    setFromMatrix(modelViewProjection);
  }

  void Frustum::setFromMatrix(Matrix4 const& modelViewProjection)
  {
    // Left plane
    planes[0].x = modelViewProjection[3]  + modelViewProjection[0];
    planes[0].y = modelViewProjection[7]  + modelViewProjection[4];
    planes[0].z = modelViewProjection[11] + modelViewProjection[8];
    planes[0].w = modelViewProjection[15] + modelViewProjection[12];

    // Right plane
    planes[1].x = modelViewProjection[3]  - modelViewProjection[0];
    planes[1].y = modelViewProjection[7]  - modelViewProjection[4];
    planes[1].z = modelViewProjection[11] - modelViewProjection[8];
    planes[1].w = modelViewProjection[15] - modelViewProjection[12];

    // Bottom plane
    planes[2].x = modelViewProjection[3]  + modelViewProjection[1];
    planes[2].y = modelViewProjection[7]  + modelViewProjection[5];
    planes[2].z = modelViewProjection[11] + modelViewProjection[9];
    planes[2].w = modelViewProjection[15] + modelViewProjection[13];

    // Top plane
    planes[3].x = modelViewProjection[3]  - modelViewProjection[1];
    planes[3].y = modelViewProjection[7]  - modelViewProjection[5];
    planes[3].z = modelViewProjection[11] - modelViewProjection[9];
    planes[3].w = modelViewProjection[15] - modelViewProjection[13];

    // Near plane
    planes[4].x = modelViewProjection[3]  + modelViewProjection[2];
    planes[4].y = modelViewProjection[7]  + modelViewProjection[6];
    planes[4].z = modelViewProjection[11] + modelViewProjection[10];
    planes[4].w = modelViewProjection[15] + modelViewProjection[14];

    // Far plane
    planes[5].x = modelViewProjection[3]  - modelViewProjection[2];
    planes[5].y = modelViewProjection[7]  - modelViewProjection[6];
    planes[5].z = modelViewProjection[11] - modelViewProjection[10];
    planes[5].w = modelViewProjection[15] - modelViewProjection[14];

    // Normalize all the planes
    for (uint32_t i = 0; i < 6; ++i)
    {
      const float length = 1.0f / sqrtf(planes[i].x * planes[i].x + planes[i].y * planes[i].y + planes[i].z * planes[i].z);
      planes[i].x *= length;
      planes[i].y *= length;
      planes[i].z *= length;
      planes[i].w *= length;
    }
  }

}