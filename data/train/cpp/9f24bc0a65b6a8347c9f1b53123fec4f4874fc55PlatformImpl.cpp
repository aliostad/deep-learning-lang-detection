#include "PlatformImpl.h"
#include "FileSystemAPI.h"
#include "FreeWifiAPI.h"
#include "WifiManagerAPI.h"

PlatformImpl::PlatformImpl()
{
}

API::Platform::FileSystemAPI PlatformImpl::getFileSystemAPI()
{
    return API::Platform::FileSystemAPI(new ::FileSystemAPI);
}

API::Platform::WifiManagerAPI PlatformImpl::getWifiManagerAPI()
{
    return API::Platform::WifiManagerAPI(new ::WifiManagerAPI);
}

API::Platform::FreeWifiAPI PlatformImpl::getFreeWifiAPI()
{
    return API::Platform::FreeWifiAPI(new ::FreeWifiAPI);
}
