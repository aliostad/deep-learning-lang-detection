#include "API.h"
#include "platform/Log.h"

void API::init(PlatformPtr platform_implementation)
{
    if(platform_implementation)
    {
        _api_filesystem = platform_implementation->getFileSystemAPI();
        _api_freewifi = platform_implementation->getFreeWifiAPI();
        _api_wifimanager = platform_implementation->getWifiManagerAPI();

        if(_api_filesystem && _api_freewifi && _api_wifimanager)
        {
            log("Writable Path: "+_api_filesystem->getWritablePath());

            _init_performed = initDatabase();
            log("Init finished successfully");
        }

    }
}

bool API::initDatabase()
{
    return true;
}

API* API::getInstance()
{
    static API api;
    return &api;
}

API::API()
    :
      _api_filesystem(nullptr),
      _api_wifimanager(nullptr),
      _api_freewifi(nullptr),
      _init_performed(false)
{
}
