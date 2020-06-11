#ifndef _MODEL_H
#define _MODEL_H

#include <iostream>
#include <vector>

class Model
{
  public:

  struct physicsData
  {
    std::string shape;
    float mass;
  };

  struct geometryData
  {
    std::vector<float> rawVertices;
    std::vector<float> rawNormals;
  };

  struct modelData
  {
    geometryData geometry;
    physicsData physics;
  };

  Model(modelData*);
  void fillModelData(modelData);

  float getMass()
  {
    return model->physics.mass;
  }

 private:
  Model() {}
  modelData* model;
};

#endif //MODEL_H
