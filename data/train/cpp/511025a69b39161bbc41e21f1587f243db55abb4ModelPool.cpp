#include "ModelPool.h"
#include "ModelAbstraction.h"

ModelPool::ModelPool()
{
  pvpModels = new vector<ModelAbstraction*>();
}

ModelAbstraction * ModelPool::GetModel(string name)
{
  if(pvpModels == NULL)
    return NULL;

  for(auto i : *pvpModels)
  {
    if(i->Name == name)
    {
      return i;
    }
  }
  return NULL;
}

bool ModelPool::AddModel(ModelAbstraction * model)
{
  if(model == NULL)
    return false;

  //see if model already exists
  ModelAbstraction * existing = this->GetModel(model->Name);
  if(existing != NULL)
    return false;

  this->pvpModels->push_back(model);
  return true;
}

bool ModelPool::RemoveModel(ModelAbstraction * model)
{
  if(model == NULL)
    return false;

  return this->RemoveModel(model->Name);
}

bool ModelPool::RemoveModel(string name)
{
  //see if model already exists
  ModelAbstraction * existing = this->GetModel(name);
  if(existing != NULL)
  {
    delete existing;
    existing = NULL;
    return true;
  }

  return false;
}

void ModelPool::SetModelPool(vector<ModelAbstraction*> * source)
{
  this->pvpModels = source;
}

vector<ModelAbstraction*> * ModelPool::GetModelPool()
{
  return this->pvpModels;
}
