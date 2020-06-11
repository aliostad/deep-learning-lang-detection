#include "hippo-dbus-ipc-locator.h"
#include "hippo-dbus-ipc-provider.h"

class HippoDBusIpcLocatorImpl : public HippoDBusIpcLocator
{
public:
    virtual HippoIpcProvider *createProvider(const char *url);
};

HippoDBusIpcLocator *
HippoDBusIpcLocator::getInstance()
{
    static HippoDBusIpcLocator *instance;

    if (!instance)
	instance = new HippoDBusIpcLocatorImpl();

    return instance;
}

HippoIpcProvider *
HippoDBusIpcLocatorImpl::createProvider(const char *url)
{
    return HippoDBusIpcProvider::createInstance(url);
}

