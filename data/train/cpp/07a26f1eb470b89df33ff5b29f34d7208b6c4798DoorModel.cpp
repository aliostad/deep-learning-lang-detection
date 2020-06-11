#include "DoorModel.h"

DoorModel::DoorModel(){model = NULL;}

DoorModel::DoorModel(bool m, bool s, bool i, int a, int ind){
	mirror = m;
	shift = s;
	invert = i;
	angle = a;
	index = ind;
	load();	
}

DoorModel::~DoorModel(){}

bool DoorModel::getMirror(){return mirror;}
bool DoorModel::getShift(){return shift;}
bool DoorModel::getInvert(){return invert;}
int DoorModel::getAngle(){return angle;}
int DoorModel::getIndex(){return index;}

void DoorModel::load(){
	model = MapModelContainer::getDoor(mirror, shift, invert, angle, 0, index);
}

void DoorModel::draw(float x, float y, float z){model->draw(x, y, z);}
