/*
 * Model.h
 *
 *  Created on: 21 Dec 2013
 *      Author: bert
 */

#ifndef MODEL_H_
#define MODEL_H_

#include "../OpenGL/OpenGLProgram.h"
#include "../Tetris/TetrisEngine.h"
#include "ModelPiece.h"
#include "ModelGrid.h"
#include "ModelShadow.h"

namespace Tetris3D {

class Model {
public:
	Model(OpenGLProgram* program, TetrisEngine* tetrisEngine);
	virtual ~Model();

	void Render();

	bool IsNeedToRender();

private:
	OpenGLProgram* program;
	TetrisEngine* tetrisEngine;
	ModelPiece* currentPiece;
	ModelPiece* well;
	ModelGrid* grid;
	ModelShadow* shadow;

	bool isGenerateGrid;
};

} /* namespace Tetris3D */

#endif /* MODEL_H_ */
