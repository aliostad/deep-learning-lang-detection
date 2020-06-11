#include "modeldataextractor.h"

ModelOperator::Model ModelOperator::construct(Point3D distanceToTarget, Point3D targetVelocity, Point3D missleVelocity)
{
    std::pair<float, Vector3D> distance = dekartToPolar(distanceToTarget);
    std::pair<float, Vector3D> targetV = dekartToPolar(targetVelocity);
    std::pair<float, Vector3D> chaserV = dekartToPolar(missleVelocity);

    Model result = {
        distance.first, distance.second.Alpha(), distance.second.Beta(),
        targetV.first, targetV.second.Alpha(), targetV.second.Beta(),
        chaserV.first, chaserV.second.Alpha(), chaserV.second.Beta()
     };
    return result;
}

void ModelOperator::setTargetSpeed(Model &model, const Point3D& speed)
{
    model[TARGET_SPEED] = speed.Scalar();
    Vector3D v = speed.direction();
    model[TARGET_SPEED_ALPHA] = v.Alpha();
    model[TARGET_SPEED_BETA] = v.Beta();
}

void ModelOperator::setChaserSpeed(Model &model, const Point3D& speed)
{
    model[MISSLE_SPEED] = speed.Scalar();
    Vector3D v = speed.direction();
    model[MISSLE_SPEED_ALPHA] = v.Alpha();
    model[MISSLE_SPEED_BETA] = v.Beta();
}

void ModelOperator::setDistance(Model& model, const Point3D& distance)
{
    model[DISTANCE] = distance.Scalar();
    Vector3D v = distance.direction();
    model[DISTANCE_ALPHA] = v.Alpha();
    model[DISTANCE_BETA] = v.Beta();
}

Point3D ModelOperator::targetSpeed(const Model& model)
{
    return Vector3D(model[TARGET_SPEED_ALPHA], model[TARGET_SPEED_BETA]) * model[TARGET_SPEED];
}

Point3D ModelOperator::chaserSpeed(const Model& model)
{
    return Vector3D(model[MISSLE_SPEED_ALPHA], model[MISSLE_SPEED_BETA]) * model[MISSLE_SPEED];
}

Point3D ModelOperator::distance(const Model &model)
{
    return Vector3D(model[DISTANCE_ALPHA], model[DISTANCE_BETA]) * model[DISTANCE];
}

Point3D ModelOperator::MissleVelocity(const Model& model) {
    Point3D res = polarToDekart(model[MISSLE_SPEED], Vector3D(model[MISSLE_SPEED_ALPHA], model[MISSLE_SPEED_BETA]));
     return res;
}

Point3D ModelOperator::TargetVelocity(const Model& model) {
    Point3D res = polarToDekart(model[TARGET_SPEED], Vector3D(model[TARGET_SPEED_ALPHA], model[TARGET_SPEED_BETA]));
     return res;
}

Point3D ModelOperator::RelativePosition(const Model& model)
{
    Point3D result = polarToDekart(model[DISTANCE], Vector3D(model[DISTANCE_ALPHA], model[DISTANCE_BETA]));
    return result;
}
