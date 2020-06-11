/**
 * @file ModelProxy.cpp
 * @brief ModelProxy
 * @author Masashi Kayahara <sylphs.mb@gmail.com>
 * @version 0.0.1
 * @date 2011-12-18
 */

#include "CommonDef.h"
#include "ModelProxy.h"
#include "ModelFactoryBuilder.h"
#include "AbstractModelFactory.h"

namespace xmc {

// Constractor
ModelProxy::ModelProxy()
{
}

// Destractor
ModelProxy::~ModelProxy()
{
    for(QMap< ModelTypeEnum , AbstractModel*>::iterator it = mModelMap.begin() ; it != mModelMap.end() ; ++it ) {
        delete it.value();
    }
}

// getModel
int ModelProxy::getModel( const ModelTypeEnum aType ,
                          AbstractModel*& aModel )
{
    QMap< ModelTypeEnum , AbstractModel* >::ConstIterator it = mModelMap.find( aType );
    if( mModelMap.constEnd() == it ) {
        ModelFactoryBuilder builder;
        AbstractModelFactory factory;
        if( GET_ERROR != builder.createFactory( aType , factory ) ) {
            AbstractModel*  model = factory.createModel();
            mModelMap.insert( aType , model );
            aModel =  model;
            return GET_OK;
        }
    }
    return GET_ERROR;
}

} // namespace end

