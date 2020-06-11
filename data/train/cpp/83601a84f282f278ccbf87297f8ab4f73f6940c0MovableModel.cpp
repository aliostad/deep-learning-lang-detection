#include "MovableModel.h"

MovableModel::MovableModel() : 
  Model(),
  velocity(Eigen::Vector3f(0.f, 0.f, -0.2f)),
  accelaration(Eigen::Vector3f(0.f, 0.f, 0.f)) {
}

MovableModel::MovableModel(Eigen::Vector3f position, Eigen::Vector3f rotation, 
  Eigen::Vector3f scale, Eigen::Vector3f color, float radius,
  Geometry* m, Eigen::Vector3f v, Eigen::Vector3f a) :
  Model(position, rotation, scale, color, radius, m),
  velocity(v),
  accelaration(a) {
}

MovableModel::~MovableModel() {}

void MovableModel::hit_model(Model* other) {
	if(dead)
		return;
	health--;
	if(health <= 0)
		destroy_model();
}

void MovableModel::add_model(struct kdtree* tree) {
	bounding_shape->add_model(tree);
}

void MovableModel::update() {
	if(!this->mesh) {
		return;
	}
	this->position += velocity;
}