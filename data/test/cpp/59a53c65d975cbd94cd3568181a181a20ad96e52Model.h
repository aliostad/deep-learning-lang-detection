#ifndef __MODEL_H__
#define __MODEL_H__
#include <gl/glut.h>
#include <vector>
#include "common.h"

class ModelPart 
{
private:
	GLuint textureId;
	float* points;
	float* normals;
	float* texCoords;
	int size;
	int maxSize;

	ModelPart& operator= (const ModelPart&);
	ModelPart(const ModelPart&);
	void reAlloc();

public:
	void add(Vector3d point, Vector3d normal, Vector3d texCoord);
	ModelPart(GLuint textureId, int maxSize);
	void draw();
	~ModelPart();
};

class Model 
{
	std::vector<ModelPart*> parts;

	Model& operator= (const Model&);
	Model(const Model&);

public:
	Model() {};
	void draw();
	void add(ModelPart* part);
	~Model();
};


#endif