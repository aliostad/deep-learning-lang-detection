/*!
 * @file ModelManager.cpp
 * @brief  ModelManager
 * @author Masashi Kayahara <sylphs.mb@gmail.com>
 * @version 0.0.1
 * @date 2011-12-16
 */
#ifndef MODEL_MANAGER_H
#define MODEL_MANAGER_H

#include "CommonDef.h"
#include "ModelManager.h"
#include "ModelProxy.h"

namespace xmc {

ModelManager* ModelManager::mInstance = NULL;

// getInstance
ModelManager* ModelManager::getInstance( )
{
    if ( NULL == mInstance) {
        mInstance = new ModelManager();
    }
    return mInstance;
}

// Constractor
ModelManager::ModelManager()
	:mModelProxy(*( new ModelProxy() ) )
{
}

// Destractor
ModelManager::~ModelManager()
{
	delete &mModelProxy;
}

// getModel
int ModelManager::getModel( const ModelTypeEnum& aType , AbstractModel*& aModel ) const
{
    return mModelProxy.getModel( aType , aModel );
  //  return 0;
}

} // namespace end

#endif // MODEL_MANAGER_H
