#include "instanceModel.h"

InstanceModel::InstanceModel(Model* model) {
  instance = model;
  modelView = mat4(1);
  worldMatrix = mat4(1);
  projection = mat4(1);
}

void InstanceModel::render() {
  mat4 oldModelView = instance->getModelView(),
       oldWorldMatrix = instance->getWorldMatrix(),
       oldProjection = instance->getProjection();

  //use new settings
  instance->setModelView(modelView);
  instance->setWorldMatrix(worldMatrix);
  instance->setProjection(projection);

  //render
  instance->render();

  //revert
  instance->setModelView(oldModelView);
  instance->setWorldMatrix(oldWorldMatrix);
  instance->setProjection(oldProjection);
}

void InstanceModel::setModelView(mat4 mat) {
  modelView = mat;
}

void InstanceModel::setWorldMatrix(mat4 mat) {
  worldMatrix = mat;
}

void InstanceModel::setProjection(mat4 mat) {
  projection = mat;
}

mat4 InstanceModel::getModelView() {
  return modelView;
}

mat4 InstanceModel::getWorldMatrix() {
  return worldMatrix;
}

mat4 InstanceModel::getProjection() {
  return projection;
}
