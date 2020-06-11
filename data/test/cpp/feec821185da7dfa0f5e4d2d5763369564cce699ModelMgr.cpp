/*
** ModelMgr.cpp for Heex
*/

#include "ModelMgr.h"
#include "Object.h"

ModelMgr::ModelMgr() : _modelMap()
{
    _modelMap[1] = new Model(1, 1.0f * MAP_PRECISION, 1.0f * MAP_PRECISION, 1.0f * MAP_PRECISION);
    _modelMap[2] = new Model(2, 0.6f, 0.6f, 1.8f, 255);
}

ModelMgr::~ModelMgr()
{
    for (std::map<uint32, Model*>::iterator itr = _modelMap.begin(); itr != _modelMap.end(); ++itr)
        delete itr->second;
}

ModelMgr* ModelMgr::instance()
{
    static ModelMgr* object = NULL;

    if (!object)
        object = new ModelMgr;
    return object;
}

ModelBox ModelMgr::GetModelBox(Object const* obj) const
{
    Position pos;
    obj->GetPosition(pos);
    return GetModelBoxAtPos(pos.posX, pos.posY, pos.posZ, obj->GetModelId());
}

ModelBox ModelMgr::GetModelBoxAtPos(float x, float y, float z, uint32 modelid) const
{
    Model const* model = GetModel(modelid);
    if (!model)
        throw UnknowModelExcept();

    ModelBox box;
    box.min.x = x - (model->width / 2.0f);
    box.min.y = y - (model->height / 2.0f);
    box.min.z = z;
    box.max.x = x + (model->width / 2.0f);
    box.max.y = y + (model->height / 2.0f);
    box.max.z = z + model->zsize;
    
    return box;
}

Model const* ModelMgr::GetModel(Object const* obj) const
{
    return GetModel(obj->GetModelId());
}

Model const* ModelMgr::GetModel(uint32 id) const
{
    std::map<uint32, Model*>::const_iterator itr = _modelMap.find(id);
    if (itr != _modelMap.end())
        return itr->second;
    return NULL;
}
