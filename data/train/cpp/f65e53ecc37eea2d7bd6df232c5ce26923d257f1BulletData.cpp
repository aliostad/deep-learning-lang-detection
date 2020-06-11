/*
 * BulletData.cpp
 *
 *  Created on: Aug 26, 2012
 *      Author: dong
 */
#include "BulletData.h"
#include <string>
std::ostream & operator<< (std::ostream & stream, const BulletData & data){
	stream << '[' << data.name << ']'<<'\n';
	stream << "Shading: "<<data.shading.r<<' '<<data.shading.g<<' '<<data.shading.b<<'\n';
	stream << "Rotation: "<<data.rotation<<"\n";
	stream << "Explosive: \n";
	stream << "    Timer: "<<data.explosive.timer<<'\n';
	stream << "    Force: "<<data.explosive.force<<'\n';
	stream << "Weight: "<<data.weight<<'\n';
	stream << "Speed: "<<data.speed<<'\n';
	stream << "Power Drain: "<<data.powerDrain<<'\n';
	return stream;
}
std::istream & operator>> (std::istream & stream, BulletData & data){
	stream.ignore(1000,'[');
	std::getline(stream,data.name,']');
	stream.ignore(1000,':');//Shading:
	stream >> data.shading.r >>data.shading.g >>data.shading.b;
	stream.ignore(1000,':');//Rotation:
	stream>>data.rotation;
	stream.ignore(1000,':');//Explosive:
	stream.ignore(1000,':');//Timer:
	stream>>data.explosive.timer;
	stream.ignore(1000,':');//Force:
	stream>>data.explosive.force;
	stream.ignore(1000,':');//Weight:
	stream >> data.weight;
	stream.ignore(1000,':');//Speed:
	stream >> data.speed;
	stream.ignore(1000,':');//Power Drain:
	stream >> data.powerDrain;
	return stream;
}
