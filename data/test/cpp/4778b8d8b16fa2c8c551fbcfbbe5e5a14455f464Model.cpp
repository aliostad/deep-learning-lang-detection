#include "Model.h"

Model::~Model() {
	if (this->model) {
		//glmDelete(this->model);
	}
}

void Model::revert(Axis axis) {
	this->axis = axis;
}

void Model::load(const char* filename) {
	this->model = glmReadOBJ((char*)filename);
}

void Model::render(unsigned int mode) {
	if (!this->model) {
		return;
	}
	if (this->axis == XZY) {
		glPushMatrix();
			glRotatef(270, 1, 0, 0);
			glmDraw(this->model, mode);
		glPopMatrix();
	}
	else {
		glmDraw(this->model, mode);
	}
}

void Model::scale(float scale) {
	glmScale(this->model, scale);
}