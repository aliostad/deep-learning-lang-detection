#include "tank.h"
#include "model.h"

Tank::Tank(Model *bodyModel, Model *towerModel) : Unit()
{
    this->bodyModel = bodyModel;
    this->towerModel = towerModel;
}

void Tank::draw(QMatrix4x4 modelview) {
    QMatrix4x4 bodyModelView, towerModelView;
    bodyModelView = towerModelView = modelview;
    transform(&bodyModelView);
    transform(&towerModelView, Scale | Translate);
    towerModelView.rotate(towerRotation.z(), 0, 0, 1);
    towerModelView.rotate(towerRotation.y(), 0, 1, 0);
    towerModelView.rotate(towerRotation.x(), 1, 0, 0);
    bodyModel->draw(bodyModelView, new QVector3D(0,0,0));
//    towerModelView.translate(0, 0, bodyModel->size().z() / 2);
    towerModel->draw(towerModelView, new QVector3D(0,0,0));
}
