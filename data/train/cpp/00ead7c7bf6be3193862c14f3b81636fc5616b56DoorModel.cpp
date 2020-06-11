#include "DoorModel.h"
#include "../../../world/World.h"

DoorModel::DoorModel(){model = NULL; motion = STEADY;}

DoorModel::DoorModel(bool m, bool s, bool i, int a, int ind){
	mirror = m;
	shift = s;
	invert = i;
	angle = a;
	index = ind;
	motion = STEADY;
	load();	
}

DoorModel::~DoorModel(){}

bool DoorModel::getMirror(){return mirror;}
bool DoorModel::getShift(){return shift;}
bool DoorModel::getInvert(){return invert;}
int DoorModel::getAngle(){return angle;}
int DoorModel::getIndex(){return index;}
Vertex* DoorModel::getCenter(){return model->getCenter();}
Model* DoorModel::getModel(){return model;}
void DoorModel::setMotion(int s){motion = s;}

void DoorModel::load(){
	model = MapModelContainer::getDoor(mirror, shift, invert, angle, 0, index);
}

void DoorModel::draw(float x, float y, float z){
	if(motion != STEADY){
		if(motion == CLOSING)
			angle--;
		else
			angle++;	
		load();		
		if(angle == motion){
			motion = STEADY;
			World::getSelectedMap()->clearVision(KNOWN, true);
		}
	}
	model->draw(x, y, z);
}
