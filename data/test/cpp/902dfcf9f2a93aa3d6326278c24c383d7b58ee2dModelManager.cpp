#include "../stdafx.h"
#include "ModelManager.h"


ModelManager::ModelArray ModelManager::mModels;
std::vector<uint32_t> ModelManager::mFreeList;

ModelManager::ModelManager(void)
{
}


ModelManager::~ModelManager(void)
{
}


ModelHandle ModelManager::newModel()
{
	Model m;
	return GenericHandleManager::newHandle< ModelHandle, Model >( m, mModels, mFreeList );
}

ModelHandle ModelManager::newModel(Model & m)
{
	return GenericHandleManager::newHandle< ModelHandle, Model >( m, mModels, mFreeList );
}

Model & ModelManager::fromHandle( ModelHandle handle )
{
	return GenericHandleManager::fromHandle( handle, mModels );
}

bool ModelManager::isValidHandle( ModelHandle handle )
{
	return GenericHandleManager::isValidHandle( handle, mModels );
}

void ModelManager::deleteModel( ModelHandle handle )
{
	GenericHandleManager::deleteHandle( handle, mModels, mFreeList );
}

void ModelManager::clearAll()
{
	GenericHandleManager::clearAll( mModels, mFreeList );
}