
#include "precomp.h"
#include "model_app_model.h"
#include <memory>

using namespace uicore;

ModelAppModel::ModelAppModel()
{
	if (instance_ptr) throw std::exception();
	instance_ptr = this;
}

ModelAppModel::~ModelAppModel()
{
	instance_ptr = 0;
}

void ModelAppModel::open(const std::string &filename)
{
	desc = ModelDesc::load(filename);
	open_filename = filename;
	set_fbx_model(desc.fbx_filename);
	sig_load_finished();
}

void ModelAppModel::save(const std::string &filename)
{
	desc.save(filename);
	open_filename = filename;
}

void ModelAppModel::set_fbx_model(const std::string &filename)
{
	desc.fbx_filename = filename;
	fbx = FBXModel::load(desc.fbx_filename);
	update_scene_model();
}

void ModelAppModel::update_scene_model()
{
	if (fbx)
		model_data = fbx->convert(desc);
	else
		model_data.reset();

	sig_model_data_updated();
}

ModelAppModel *ModelAppModel::instance()
{
	return instance_ptr;
}

ModelAppModel *ModelAppModel::instance_ptr = 0;
