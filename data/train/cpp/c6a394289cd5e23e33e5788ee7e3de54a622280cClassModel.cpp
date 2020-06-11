#include "ClassModel.h"

void model::setX(double fromX)
{
	this->x = fromX;
}
double model::getX()
{
	return this->x;
}

void model::setY(double fromY)
{
	this->y = fromY;
}
double model::getY()
{
	return y;
}

void model::setZ(double fromZ)
{
	z = fromZ;
}
double model::getZ()
{
	return z;
}

void model::setW(double fromW)
{
	w = fromW;
}
double model::getW()
{
	return w;
}

void model::setInitClass(int fromInitClass)
{
	initClass = fromInitClass;
}
int model::getInitClass()
{
	return initClass;
}

void model::setCalcClass(int fromCalcClass)
{
	calcClass = fromCalcClass;	
}
int model::getCalcClass()
{
	return calcClass;
}

model model::operator=(const model &data)
{
	x = data.x;
	y = data.y;
	z = data.z;
	w = data.w;
	initClass = data.initClass;
    calcClass = data.calcClass;

	return *this;
}
model model::operator+=(const model &data)
{
    x += data.x;
    y += data.y;
    z += data.z;
    w += data.w;
    
    return *this;
}
/*
model model::operator+(const model &data)
{
    x += data.x;
    y += data.y;
    z += data.z;
    w += data.w;
    
    return *this;
}
 */
model model::operator/(int d)
{
    x /= d;
    y /= d;
    z /= d;
    w /= d;
    
    return *this;
}

//centerModel
centerModel centerModel::operator=(const model &data)
{
	x = data.x;
	y = data.y;
	z = data.z;
	w = data.w;
	initClass = data.initClass;
    calcClass = data.calcClass;

	return *this;
}
centerModel centerModel::operator=(const centerModel &data)
{
    x = data.x;
	y = data.y;
	z = data.z;
	w = data.w;
	initClass = data.initClass;
    calcClass = data.calcClass;
    
	return *this;
}

centerModel centerModel::operator+(const model &data)
{
    x += data.x;
    y += data.y;
    z += data.z;
    w += data.w;
    
    return *this;
}

centerModel centerModel::operator/(int d)
{
    x /= d;
    y /= d;
    z /= d;
    w /= d;
    
    return *this;
}

bool centerModel::operator==(const centerModel &data)
{
    if (x==data.x && y==data.y && z==data.z && w==data.w)
    {
        return 1;
    }
    else
        return 0;
}

ostream &operator<<(std::ostream &os, const centerModel &data)
{
    os<<data.x<<'\t'<<data.y<<'\t'<<data.z<<'\t'<<data.w;
    return os;
}

