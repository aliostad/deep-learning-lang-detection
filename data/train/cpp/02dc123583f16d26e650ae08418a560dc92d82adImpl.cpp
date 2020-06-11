#include "Interface.h"
#include "GlobalConfig.h"
#include "Model.h"

extern "C"
{
	void bkl2d_globalInit(bkl2d_init_struct *s)
	{
		Live2D::init();
		if (s)
		{
			readDataFromFile = s->_readDataFromFile;
			freeData = s->_freeData;
			loadTextureFromFile = s->_loadTextureFromFile;
			freeTexture = s->_freeTexture;
			playSound = s->_playSound;
			stopSound = s->_stopSound;
			getRealTimeVolumeOfSound = s->_getRealTimeVolumeOfSound;
			sendError = s->_sendError;
		}
	}

	void bkl2d_globalDestroy()
	{
		BKL2D_Model::destroyAll();
		Live2D::dispose();
	}

	int32_t bkl2d_newModel(const char *file)
	{
		return BKL2D_Model::create(file);
	}

	void bkl2d_getModelCanvasSize(int32_t id, float *w, float *h)
	{
		BKL2D_Model *model = BKL2D_Model::modelFromID(id);
		if (model)
		{
			model->getCanvasSize(w, h);
			return;
		}
		*w = 0;
		*h = 0;
	}

	void bkl2d_freeModel(int32_t id)
	{
		BKL2D_Model::destroy(id);
	}

	void bkl2d_setMatrix(int32_t id, float *matrix)
	{
		BKL2D_Model *model = BKL2D_Model::modelFromID(id);
		if (model)
		{
			model->setMatrix(matrix);
		}
	}

	void bkl2d_draw(int32_t id)
	{
		BKL2D_Model *model = BKL2D_Model::modelFromID(id);
		if (model)
		{
			model->draw();
		}
	}

	void bkl2d_setTap(int32_t id, float x, float y)
	{
		BKL2D_Model *model = BKL2D_Model::modelFromID(id);
		if (model)
		{
			model->tapEvent(x, y);
		}
	}

	void bkl2d_setDrag(int32_t id, float x, float y)
	{
		BKL2D_Model *model = BKL2D_Model::modelFromID(id);
		if (model)
		{
			model->dragEvent(x, y);
		}
	}

	void bkl2d_setFlick(int32_t id, float x, float y)
	{
		BKL2D_Model *model = BKL2D_Model::modelFromID(id);
		if (model)
		{
			model->flickEvent(x, y);
		}
	}

}