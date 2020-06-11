// Copyright 2016 Marc Comino

#include "./cube_util.h"

#include <geometry_util.h>

namespace data_representation {

namespace {

const double kMinTheta = 0;
const double kTheta = 2 * M_PI;
const double kMinPsi = -M_PI / 2.0;
const double kPsi = M_PI;

void PushVertex(double x, double y, double z,
                data_representation::ModelD* model) {
  model->vertices_.push_back(x);
  model->vertices_.push_back(y);
  model->vertices_.push_back(z);
}

void PushTexCoord(double s, double t, data_representation::ModelD* model) {
  model->tex_coords_.push_back(s);
  model->tex_coords_.push_back(t);
}

void PushFace(int v1, int v2, int v3, data_representation::ModelD* model) {
  model->faces_.push_back(v1);
  model->faces_.push_back(v2);
  model->faces_.push_back(v3);
}

}  //  namespace

void ModelFromCube(data_representation::ModelD* model) {
  PushVertex(1, -1, -1, model);
  PushVertex(1, -1, 1, model);
  PushVertex(1, 1, 1, model);
  PushVertex(1, 1, -1, model);

  PushTexCoord(0, 0, model);
  PushTexCoord(0, 1, model);
  PushTexCoord(1, 1, model);
  PushTexCoord(1, 0, model);

  PushVertex(-1, -1, -1, model);
  PushVertex(1, -1, -1, model);
  PushVertex(1, 1, -1, model);
  PushVertex(-1, 1, -1, model);

  PushTexCoord(0, 0, model);
  PushTexCoord(0, 1, model);
  PushTexCoord(1, 1, model);
  PushTexCoord(1, 0, model);

  PushVertex(-1, -1, -1, model);
  PushVertex(-1, -1, 1, model);
  PushVertex(-1, 1, 1, model);
  PushVertex(-1, 1, -1, model);

  PushTexCoord(0, 0, model);
  PushTexCoord(0, 1, model);
  PushTexCoord(1, 1, model);
  PushTexCoord(1, 0, model);

  PushVertex(-1, -1, 1, model);
  PushVertex(1, -1, 1, model);
  PushVertex(1, 1, 1, model);
  PushVertex(-1, 1, 1, model);

  PushTexCoord(0, 0, model);
  PushTexCoord(0, 1, model);
  PushTexCoord(1, 1, model);
  PushTexCoord(1, 0, model);

  PushVertex(-1, 1, -1, model);
  PushVertex(-1, 1, 1, model);
  PushVertex(1, 1, 1, model);
  PushVertex(1, 1, -1, model);

  PushTexCoord(0, 0, model);
  PushTexCoord(0, 1, model);
  PushTexCoord(1, 1, model);
  PushTexCoord(1, 0, model);

  PushFace(0, 3, 2, model);
  PushFace(0, 2, 1, model);
  PushFace(4, 7, 6, model);
  PushFace(4, 6, 5, model);
  PushFace(8, 10, 11, model);
  PushFace(8, 9, 10, model);
  PushFace(12, 14, 15, model);
  PushFace(12, 13, 14, model);
  PushFace(16, 18, 19, model);
  PushFace(16, 17, 18, model);

  ::geometry::ComputeFaceNormals(model->vertices_, model->faces_,
                                 &model->face_normals_);
  ::geometry::ComputeVertexNormals(model->vertices_, model->face_normals_,
                                   model->faces_, &model->vertex_normals_);

  ::geometry::ComputeBoundingBox(model->vertices_, &model->bounding_box_);
}

}  //  namespace data_representation
