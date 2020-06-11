#ifndef BLND_MODEL_OLD_H
#define BLND_MODEL_OLD_H

#include "stdafx.h"
#include "blondengine/rendering/content/ModelContent.h"


class Model
{

public:
	Model() {}
	Model(ModelContent * model) : model(model) {}

	virtual ~Model() { Release(); }
	void Release();

	void SetModel(ModelContent * model) { Release(); this->model = model; }
	ModelContent * GetModel() { return model; }

	void RenderSimple(LPDIRECT3DDEVICE9  pDevice, D3DXMATRIX & transform);
	void Render(LPDIRECT3DDEVICE9  pDevice);

private:
	ModelContent * model;		// The actual mesh.
};

#endif