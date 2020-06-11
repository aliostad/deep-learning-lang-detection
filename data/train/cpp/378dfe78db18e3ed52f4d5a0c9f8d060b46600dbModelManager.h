#ifndef __MODEL_MANAGER_H__
#define __MODEL_MANAGER_H__

/*
 * This class's main job is to store all the models
 * and provide to the UnitBlock variables when needed.
 */

#include <iostream>
#include "..\Common\Global.h"
#include "Model.h"
#include "MilkshapeModel.h"
using namespace std;

enum eBlockType;

class ModelManager {
private:
	Model								*pModel1x1x1Upper;
	Model								*pModel1x1x1Lower;

	Model								*pModel1x2x1Upper;
	Model								*pModel1x2x1Lower;

	Model								*pModel2x1x1Upper;
	Model								*pModel2x1x1Lower;

	Model								*pModel2x2x1Upper;/*yakexi*/
	Model								*pModel2x2x1Lower;

	Model								*pModel3x1x1Upper;
	Model								*pModel3x1x1Lower;

	Model								*pModel3x1x2Upper;
	Model								*pModel3x1x2Lower;

	Model								*pModel4x1x1Upper;
	Model								*pModel4x1x1Lower;

	Model								*pModel4x1x2Upper;
	Model								*pModel4x1x2Lower;

	Model								*pModelSaberStand;
	Model								*pModelSaberLeft;
	Model								*pModelSaberRight;

	bool								PreloadModel(Model*& model, const char *filename);
	bool								UnloadModel(Model*& model);

	inline Model						*GetModel1x1x1Upper() const					{ return pModel1x1x1Upper; }
	inline Model						*GetModel1x1x1Lower() const					{ return pModel1x1x1Lower; }

	inline Model						*GetModel1x2x1Upper() const					{ return pModel1x2x1Upper; }
	inline Model						*GetModel1x2x1Lower() const					{ return pModel1x2x1Lower; }

	inline Model						*GetModel2x1x1Upper() const					{ return pModel2x1x1Upper; }
	inline Model						*GetModel2x1x1Lower() const					{ return pModel2x1x1Lower; }

	inline Model						*GetModel2x2x1Upper() const					{ return pModel2x2x1Upper; }/*yakexi*/
	inline Model						*GetModel2x2x1Lower() const					{ return pModel2x2x1Lower; }

	inline Model						*GetModel3x1x1Upper() const					{ return pModel3x1x1Upper; }
	inline Model						*GetModel3x1x1Lower() const					{ return pModel3x1x1Lower; }

	inline Model						*GetModel3x1x2Upper() const					{ return pModel3x1x2Upper; }
	inline Model						*GetModel3x1x2Lower() const					{ return pModel3x1x2Lower; }

	inline Model						*GetModel4x1x1Upper() const					{ return pModel4x1x1Upper; }
	inline Model						*GetModel4x1x1Lower() const					{ return pModel4x1x1Lower; }

	inline Model						*GetModel4x1x2Upper() const					{ return pModel4x1x2Upper; }
	inline Model						*GetModel4x1x2Lower() const					{ return pModel4x1x2Lower; }

public:
	bool								PreloadAllModels();
	bool								UnloadAllModels();

	Model								*GetModel(eBlockType bt, bool upp);

	Model								*GetSaberStand() const					{ return pModelSaberStand; }
	Model								*GetSaberLeft() const					{ return pModelSaberLeft; }
	Model								*GetSaberRight() const					{ return pModelSaberRight; }

};

#endif ///> end of __MODEL_MANAGER_H__