#ifndef __MODEL_H__
#define __MODEL_H__

#include <list>
#include "UtilityFuncs.h"
#include "Renderer.h"

#include <stdio.h>

class Model	// model class
{
private:
	std::list<ModelPolygon*> m_pPolygons ; // polygons in the model
	Point ptModelBBNegatives, ptModelBBPositives ; // bounding box

public:
	Model() ;
	~Model() ;

	void AddPolygon(ModelPolygon *pAddPolygon) ;
	void ReadMLFile(char *szFilename) ;	// read in ML file
	void ReadML2File(char *szFilename) ; // read in ML2 file

	void Display() ;	// display the model
} ;

#endif