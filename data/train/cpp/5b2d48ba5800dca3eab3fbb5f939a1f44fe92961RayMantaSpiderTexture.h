/*
 Copyright (C) Johan Ceuppens 2011
*/
#ifndef _RAYSPIDERTEXTURE_H_
#define _RAYSPIDERTEXTURE_H_

#include<vector>
#include "RayMantaPoint.h"
#include "RayMantaPixmapImage.h"
#include "RayMantaEngine.h"
#include "RayMantaTexture.h"

namespace ray3d {

class SpiderModel;

class SpiderTexture : public Texture {
public:
	SpiderTexture (double alpha, double beta, double gamma) : Texture(alpha,beta,gamma),_legw(80),_legh(60),_legz(10),_thetax(alpha),_thetay(beta),_thetaz(gamma) {}
	virtual ~SpiderTexture() {}

	virtual int initdraw(SpiderModel& model);
	//diagonal spider leg (can be filed out)
	virtual int initspiderleg(SpiderModel& model);

	//clyndrical primitives and ditherings
	virtual int initclover(SpiderModel& model);
	//virtual int initconeorcylinderY(SpiderModel& model);
	virtual int initconeorcylindergrowY(SpiderModel& model);
	virtual int initconeorcylinderditherY(SpiderModel& model);
	virtual int initconeorcylinderdither2Y(SpiderModel& model);
	virtual int initconeorcylindersmallpatternY(SpiderModel& model);
	virtual int initconeorcylindersinkY(SpiderModel& model);
	virtual int initconeorcylindercurvedY(SpiderModel& model);
	virtual int rotatemodel(SpiderModel& model);

protected:

	virtual int initdraw1(SpiderModel& model);
	int _legw, _legh,_legz;
	double _thetax, _thetay, _thetaz;//FIXME11 remove
};

}

#endif
