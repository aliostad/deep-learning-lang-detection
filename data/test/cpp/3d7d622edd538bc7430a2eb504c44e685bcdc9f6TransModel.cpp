#include "TransModel.h"

TransModel::TransModel(string path) : Model(path)
{
	
}

TransModel::TransModel(void)
{
}

TransModel::~TransModel(void)
{
}

TransModel::Transform TransModel::getTransform()
{
	return transform;
}

void TransModel::setTransform(cv::Mat s, cv::Mat o)
{
	transform = Transform(s, o);
}

// Transform functions
#pragma region
TransModel::Transform::Transform(void)
{
}

TransModel::Transform::Transform(cv::Mat s, cv::Mat o)
{
	scale = s;
	offset = o;
}

cv::Mat TransModel::Transform::getScale()
{
	return scale;
}
cv::Mat TransModel::Transform::getOffset()
{
	return offset;
}
#pragma endregion
