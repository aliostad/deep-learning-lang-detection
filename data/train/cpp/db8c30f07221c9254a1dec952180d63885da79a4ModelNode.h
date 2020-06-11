#ifndef MODEL_NODE_H
#define MODEL_NODE_H

#include "OpenGL.h"
#include "Model.h"

#define MODEL_NAME_SIZE 32

class ModelNodeLink
{
public:
	ModelNodeLink()
	{
		this->next = 0;
		this->prev = 0;
	}

	~ModelNodeLink()
	{
		delete next;
		delete prev;
	}

	ModelNodeLink *next;
	ModelNodeLink *prev;
};

class ModelNode : public ModelNodeLink
{
public:
	ModelNode();
	~ModelNode();

	void set( const char * const inModelName,
				GLuint inHash,
				Model * inMod);

public:	
	// name of model from file
	char modelName[ MODEL_NAME_SIZE ];

	// hashed model name
	GLuint hashName;

	// VAO reference to model in GPU
	Model *storedModel;

};

#endif