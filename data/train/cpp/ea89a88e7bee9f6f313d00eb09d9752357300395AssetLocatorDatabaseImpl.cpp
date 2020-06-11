#include "AssetLocatorDatabaseImpl.h"
#include "AssetLocatorSQLLiteDatabase.h"

namespace cards {
    AssetLocatorDatabaseImpl::AssetLocatorDatabaseImpl()
    {
      database = new AssetLocatorSQLLiteDatabase("AssetLocator.db");
    }

    AssetLocatorDatabaseImpl::~AssetLocatorDatabaseImpl()
    {
      delete database;
    }

    AssetLocator::Locations
    AssetLocatorDatabaseImpl::getFilepath( AssetTag* assetTag ) const
    {
      return database->query(assetTag->getName());
    }

    // Asset Management
    void
    AssetLocatorDatabaseImpl::removeAsset( AssetTag* assetTag )
    {
      database->remove(assetTag->getName());
    }

    // Location Management
    void
    AssetLocatorDatabaseImpl::addLevelOfDetailLocation( AssetTag* assetTag, unsigned int lod, std::string location )
    {
      database->insert(assetTag->getName(), lod, location);
    }

    void
    AssetLocatorDatabaseImpl::removeLevelOfDetailLocation( AssetTag* assetTag, unsigned int lod )
    {
      database->remove(assetTag->getName(), lod);
    }

    void
    AssetLocatorDatabaseImpl::updateLevelOfDetailLocation( AssetTag* assetTag, unsigned int lod, std::string location )
    {
      database->update(assetTag->getName(), lod, location);
    }

}
