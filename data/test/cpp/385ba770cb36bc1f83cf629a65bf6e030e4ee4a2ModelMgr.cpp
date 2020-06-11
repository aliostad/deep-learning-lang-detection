#include "ModelMgr.h"


using namespace vivid;

//======================================================================
ModelMgr::ModelMgr ()
{ }

//======================================================================
ModelMgr::~ModelMgr ()
{ }

//======================================================================
bool ModelMgr::Initialize ()
{
	return true;
}

//======================================================================
void ModelMgr::Shutdown ()
{
	models.Clear ();
}

//======================================================================
ModelHandle ModelMgr::Create ()
{
	return ModelHandle (models.CreateElement ());
}

//======================================================================
void ModelMgr::Delete (const ModelHandle& model)
{
	models.DeleteElement (model.handle);
}

//======================================================================
bool ModelMgr::Validate (const ModelHandle& model)
{
	return models.Validate (model.handle);
}

//======================================================================
Model& ModelMgr::Get (const ModelHandle& model)
{
	return models.At (model.handle);
}
