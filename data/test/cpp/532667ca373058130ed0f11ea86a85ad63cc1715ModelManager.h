#pragma once

#include "Handles.h"
#include "GenericHandleManager.h"
#include "Model.h"

class ModelManager
{
public:
	ModelManager(void);
	~ModelManager(void);

	static ModelHandle newModel();

	static ModelHandle newModel(Model & m);

	static Model & fromHandle( ModelHandle handle );

	static bool isValidHandle( ModelHandle handle );

	static void deleteModel( ModelHandle handle );

	static void clearAll();

protected:
	typedef std::vector< GenericHandleManager::ItemDescription< Model > > ModelArray;

	static ModelArray mModels;
	static std::vector<uint32_t> mFreeList;
};

