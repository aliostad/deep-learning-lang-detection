#include "UnbreakableModel.h"

UnbreakableModel::UnbreakableModel(){model = NULL;}

UnbreakableModel::UnbreakableModel(int t, bool m, int i){
	type = t;
	mirror = m;
	index = i;
	load();
}

UnbreakableModel::~UnbreakableModel(){}

int UnbreakableModel::getType(){return type;}
bool UnbreakableModel::getMirror(){return mirror;}
int UnbreakableModel::getIndex(){return index;}
Vertex* UnbreakableModel::getCenter(){return model->getCenter();}
Model* UnbreakableModel::getModel(){return model;}

void UnbreakableModel::load(){
	model = MapModelContainer::getUnbreakable(type, mirror, index);
}

void UnbreakableModel::draw(float x, float y, float z){model->draw(x, y, z);}
