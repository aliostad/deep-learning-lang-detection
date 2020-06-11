#ifndef IMOVABLE_MODEL_H
#define IMOVABLE_MODEL_H

#ifdef _WIN32
#define EIGEN_DONT_VECTORIZE
#define EIGEN_DISABLE_UNALIGNED_ARRAY_ASSERT
#define NOMINMAX
#endif

#include "Model.h"
#include "BoundingBox.h"
#include "BoundingSphere.h"

class ImovableModel : public Model {

public:
	ImovableModel();
	ImovableModel(Eigen::Vector3f position);
	ImovableModel(Eigen::Vector3f position, Eigen::Vector3f rotation, Eigen::Vector3f scale,
		Eigen::Vector3f color, float radius, Geometry* mesh);
	
	~ImovableModel() {}

	void data_log();

	void hit_model(Model* other);
	void add_model(struct kdtree* tree);
	void update();
};

#endif
