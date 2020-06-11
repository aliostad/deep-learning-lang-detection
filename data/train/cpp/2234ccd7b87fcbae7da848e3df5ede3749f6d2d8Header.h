#include <iostream>
#include <sstream>
#include <Windows.h>
#include <NuiApi.h>//Kinect‚ð“®‚©‚·API
#include "GLMetaseq.h"
#include <gl/freeglut/glut.h>

#ifndef _Model_H_
#define _Model_H_


/*
class Skelton
{
NUI_SKELETON_FRAME skeletonFrame;
NUI_SKELETON_DATA skeletonData;
public:
Skelton();
~Skelton();

};

Skelton::Skelton()
{
}

Skelton::~Skelton()
{
}

*/

class Model
{
public:
	MQO_MODEL mqo_model;
	MQO_MATERIAL mqo_material;
	MQO_OBJECT mqo_object;

	Model();
	~Model();


};

Model::Model()
{
}

Model::~Model()
{
}


#endif _Model_H_