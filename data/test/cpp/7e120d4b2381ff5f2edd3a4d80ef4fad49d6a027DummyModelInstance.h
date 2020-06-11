#pragma once
#include "Modeler/ModelInstance.h"

class dummy_model_instance : public Graphics::ModelInstance
{
public:
	dummy_model_instance(Graphics::ModelInstance & donor_instance_,Graphics::Model           * model_ = 0):donor_instance(donor_instance_)
	{
		model = model_;
		if (!model)
		{
			model = donor_instance.GetModel();
		}
	};
	inline const Position3&            GetPosition()      { return Position3::One;};// получить позицию
	inline Graphics::Model            *GetModel()		  { return model;};   // получить модель
	inline const Graphics::DParamList& GetDrawArguments() { return donor_instance.GetDrawArguments();};    // получить список аргументов рисования
private:
	Graphics::ModelInstance   & donor_instance;
	Graphics::Model           * model;
};
