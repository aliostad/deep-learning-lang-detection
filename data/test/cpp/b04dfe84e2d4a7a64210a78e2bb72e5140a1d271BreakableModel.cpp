#include "BreakableModel.h"

BreakableModel::BreakableModel(){model = NULL;}

BreakableModel::BreakableModel(int t, bool m, bool c, int i){
	type = t;
	mirror = m;
	condition = c;
	index = i;
	load();
}

BreakableModel::~BreakableModel(){}

int BreakableModel::getType(){return type;}
bool BreakableModel::getMirror(){return mirror;}
bool BreakableModel::getCondition(){return condition;}
int BreakableModel::getIndex(){return index;}

void BreakableModel::load(){
	model = MapModelContainer::getBreakable(type, mirror, condition, index);
}

void BreakableModel::draw(float x, float y, float z){model->draw(x, y, z);}
