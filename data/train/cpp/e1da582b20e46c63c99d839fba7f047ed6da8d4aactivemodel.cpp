#include "activemodel.h"
#include "force.h"
#include <iostream>

ActiveModel::ActiveModel() : Model() {
}

ActiveModel::ActiveModel(Eigen::Vector3f pos) : Model(pos) {
}

ActiveModel::ActiveModel(Eigen::Vector3f pos, Eigen::Vector3f vel) : Model(pos) {
	velocity = vel;
}

void ActiveModel::update() {
    if (!mesh || mesh->dead) return;
    
    t += 0.033;
	position += velocity;
    bs->center = position;
}

void ActiveModel::addSelf(kdtree *tree) {
    if (bs != NULL) {
        bs->addSelf(tree);
    }
};

void ActiveModel::hit(Model *otherModel) {
	if (dead) {
        return;
    }
	health--;
	if (health <= 0) {
		die();
	}
}
