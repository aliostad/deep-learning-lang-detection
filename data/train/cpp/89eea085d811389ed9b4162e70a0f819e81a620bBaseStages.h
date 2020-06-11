#ifndef BASESTAGES_H_
#define BASESTAGES_H_

#include "Renderer/Model.h"
#include "Renderer/Geom.hpp"

namespace Renderer{

class MeshModelStage{
	const MeshModel * model;
	size_t ptr;
	std::vector<Geom::V3f> norm_v;
public:
	typedef std::tuple<Geom::TriangleF4, Geom::TriangleF, Geom::V3f, Geom::V3f>  result;
	bool have();
	result process(bool &fin);
	MeshModelStage(const MeshModel& model);
	MeshModelStage(){}
	void start();
	void operator=(MeshModelStage &&mstage);
};

class ModelStage{
	std::vector<MeshModelStage> mstage;
	int ptr;
	void next();
public:
	typedef typename MeshModelStage::result result;
	bool have();
	result process(bool &fin);
	ModelStage(const Model& model);
	ModelStage(){}
	void start();
	void operator=(ModelStage &&mstage);
};

}



#endif /* BASESTAGES_H_ */
