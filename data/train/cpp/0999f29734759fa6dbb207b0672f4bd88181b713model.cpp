#include "model.hpp"
#include "transform.hpp"

Model::Model(QObject *parent)
        : QObject(parent)
{
    mTransform = Transform();
}

Transform& Model::transform()
{
    return mTransform;
}

void Model::setTransform(Transform transform)
{
    mTransform = transform;
}

void Model::paint(Camera* camera)
{
    for (Model *child : this->findChildren<Model*>()) {
        child->paint(camera);
    }
}

void Model::update(int delta)
{
    for (Model *child : this->findChildren<Model*>()) {
        child->update(delta);
    }
}
