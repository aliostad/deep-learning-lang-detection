/*
 *  Filename: 		Scenegraph.cpp
 *  Project:		crfStressTest
 *  Author:		Stefan Broder (brods1@bfh.ch)
 *  Creation Date:	29.05.2009
 *  Purpose:		Create a scene graph with (huge) models to test the performance
 *
 */

#include "Scenegraph.h"

using namespace osg;
using namespace std;

Scenegraph::Scenegraph() {
}

Scenegraph::~Scenegraph() {
	delete _model_left, _model_center, _model_right, _model_bottom;
}

Node* Scenegraph::createScenegraph(std::string filename) {
	
	Group *scene = new Group;

	_isRotating = false;
	
	_model_left = new Model(filename);
	_model_center = new IlluminatedModel(filename, scene->getOrCreateStateSet());
	_model_right = new Model(filename);
	_model_bottom = new Model(filename);

	_model_left->setPosition(osg::Vec3d(-5.0, -1.0, -4.0));
	_model_center->setPosition(osg::Vec3d(0.0, -1.0, 0.0));
	_model_right->setPosition(osg::Vec3d(5.0, -1.0, -4.0));
	_model_bottom->setPosition(osg::Vec3d(0.0, -5.0, -4.0));

	// rotate bottom model in order not only to see the head
	_model_bottom->rotate_x(-90.0);

	scene->addChild(_model_left->getModel());
	scene->addChild(_model_center->getModel());
	scene->addChild(_model_right->getModel());
	scene->addChild(_model_bottom->getModel());
	
	return scene;
}

void Scenegraph::updateScenegraph() {

	if(_isRotating) {
	
		_model_left->rotate_rel_y(0.01);
		_model_center->rotate_rel_y(0.03);
		_model_right->rotate_rel_y(0.05);
		_model_bottom->rotate_rel_y(0.1);
	}

	_model_center->rotateLights();
}

void Scenegraph::toggleRotation() {
	_isRotating = !_isRotating;
}

void Scenegraph::toggleIllumination() {
	_model_center->toggleLights();
}
	
void Scenegraph::loadModel(std::string filename) {

	osg::ref_ptr<osg::Node> model = osgDB::readNodeFile(filename);
	
	if(model!=NULL) {
		
		_model_left->setModel(model.get());
		_model_center->setModel(model.get());
		_model_right->setModel(model.get());
		_model_bottom->setModel(model.get());
	} else {
		cerr<< "Could not load model! File " << filename << " not found." << endl;
	}
}

