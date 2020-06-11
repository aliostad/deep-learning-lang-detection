/*
  File:         OpenFreightCarriage.cpp
  Objective:    Implementations
  Edited:       2013 / Paul Frend
*/
#include "OpenFreightCarriage.h"


OpenFreightCarriage::OpenFreightCarriage(int id, double loadCapacity, int loadSurface)
	:FreightCarriage(id,"OpenFreightCarriage"),
	loadCapacity(loadCapacity),
	loadSurface(loadSurface)
{
}


OpenFreightCarriage::~OpenFreightCarriage(void)
{
}

void OpenFreightCarriage::display(ostream& os) {
	Vehicle::display(os);
	os << "loadCapacity: " << loadCapacity << endl
		<< "loadSurface: " << loadSurface << endl;
}