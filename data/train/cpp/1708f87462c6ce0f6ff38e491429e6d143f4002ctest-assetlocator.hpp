#include <AssetLocator.h>

#include <AssetTagImpl.h>

#include "cpptest.h"

class AssetLocatorTestSuite : public Test::Suite
{
public:
    AssetLocatorTestSuite( cards::AssetLocator* assetLocator, std::string className )
        : mAssetLocator( assetLocator )
    {
        mClassMsg = std::string("Class: ") + className;
        mAssetTag = new cards::AssetTagImpl( "foo" );
        location0 = "bar0";
        location1 = "bar1";
        
        TEST_ADD(AssetLocatorTestSuite::addAndRetrieveLOD)
        TEST_ADD(AssetLocatorTestSuite::addAndRetrieveSecondLOD)
        TEST_ADD(AssetLocatorTestSuite::removeAndRetrieveLOD)
        TEST_ADD(AssetLocatorTestSuite::updateAndRetrieveLOD)
        TEST_ADD(AssetLocatorTestSuite::removeToCleanupAsset)
    }

    ~AssetLocatorTestSuite()
    {
        delete mAssetTag;
    }    
private:

    std::string mClassMsg;
    cards::AssetLocator* mAssetLocator;
    cards::AssetTag* mAssetTag;
    std::string location0;
    std::string location1;

    void addAndRetrieveLOD()
    {
        mAssetLocator->addLevelOfDetailLocation( mAssetTag, 0, location0 );

        cards::AssetLocator::Locations expected;
        expected.push_back( location0 );

        TEST_ASSERT_MSG( expected == mAssetLocator->getFilepath( mAssetTag ), mClassMsg.c_str() );
    }

    void addAndRetrieveSecondLOD()
    {
        mAssetLocator->addLevelOfDetailLocation( mAssetTag, 1, location1 );

        cards::AssetLocator::Locations expected;
        expected.push_back( location0 );
        expected.push_back( location1 );

        TEST_ASSERT_MSG( expected == mAssetLocator->getFilepath( mAssetTag ), mClassMsg.c_str() );
    }

    void removeAndRetrieveLOD()
    {
        mAssetLocator->removeLevelOfDetailLocation( mAssetTag, 1 );

        cards::AssetLocator::Locations expected;
        expected.push_back( location0 );

        TEST_ASSERT_MSG( expected == mAssetLocator->getFilepath( mAssetTag ), mClassMsg.c_str() );
    }

    void updateAndRetrieveLOD()
    {
        mAssetLocator->updateLevelOfDetailLocation( mAssetTag, 0, location1 );

        cards::AssetLocator::Locations expected;
        expected.push_back( location1 );

        TEST_ASSERT_MSG( expected == mAssetLocator->getFilepath( mAssetTag ), mClassMsg.c_str() );
    }

    void removeToCleanupAsset()
    {
        TEST_ASSERT_MSG( !mAssetLocator->getFilepath( mAssetTag ).empty(),
            (mClassMsg + ":\t Missing Asset").c_str() );

        mAssetLocator->removeAsset( mAssetTag );

        TEST_ASSERT_MSG( mAssetLocator->getFilepath( mAssetTag ).empty(),
            (mClassMsg + ":\t Failed to remove asset").c_str() );
    }
};

