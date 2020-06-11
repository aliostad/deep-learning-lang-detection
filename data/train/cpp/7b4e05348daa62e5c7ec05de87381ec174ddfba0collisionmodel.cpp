#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"
#include "glm/gtx/transform.hpp"
#include "collisionmodel.h"

CollisionModel::CollisionModel(Model *model) : model_(model) {
  collision_model_ = newCollisionModel3D();
  try {
    Vec3Vector vertices = model_->vertices();
    std::size_t size = vertices.size();
    for (std::size_t i = 0; i <= size - 3; i += 3) {
      Vec3 v1 = vertices[i];
      Vec3 v2 = vertices[i + 1];
      Vec3 v3 = vertices[i + 2];
	  collision_model_->addTriangle(glm::value_ptr(v1), 
                                    glm::value_ptr(v2), 
                                    glm::value_ptr(v3));
    }
    collision_model_->finalize();
  }
  catch(...) {
    delete collision_model_;
    throw;
  }
}
CollisionModel::~CollisionModel() {
  delete collision_model_;
}
Model* CollisionModel::model() const {
  return model_;
}
CollisionModel3D* CollisionModel::collision_model() const {
  return collision_model_;
}
bool CollisionModel::Collision(CollisionModel &colmod) {
  Model *mod = colmod.model();
  CollisionModel3D *col = colmod.collision_model();
  Mat4 transform1 = model_->transform_matrix();
  Mat4 transform2 = mod->transform_matrix();
  collision_model_->setTransform(glm::value_ptr(transform1));
  col->setTransform(glm::value_ptr(transform2));
  return collision_model_->collision(col);
}