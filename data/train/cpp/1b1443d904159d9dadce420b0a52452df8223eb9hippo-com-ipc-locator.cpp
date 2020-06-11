/* hippo-com-ipc-locator.cpp: HippoIpcLocator implementation via COM for Windows
 *
 * Copyright Red Hat, Inc. 2006
 **/
#include "stdafx-hippoipc.h"

#include "hippo-bridged-ipc-controller.h"
#include "hippo-com-ipc-hub.h"
#include "hippo-com-ipc-locator.h"
#include "hippo-com-ipc-provider.h"

class HippoComIpcLocatorImpl : public HippoComIpcLocator {
public:
    HippoComIpcLocatorImpl();
    ~HippoComIpcLocatorImpl();
    virtual HippoIpcController *getController(const char *serverName);
    virtual void releaseController(HippoIpcController *controller);
    virtual HippoIpcController *createController(const char *serverName);

private:
    HippoIpcController *doGetController(const char *serverName);
    void doReleaseController(HippoIpcController *controller);
};

HippoIpcLocator *
HippoComIpcLocator::getInstance()
{
    return HippoComIpcHub::getInstance()->getLocator();
}

HippoComIpcLocator *
HippoComIpcLocator::createInstance()
{
    return new HippoComIpcLocatorImpl();
}

HippoComIpcLocatorImpl::HippoComIpcLocatorImpl()
{
}

HippoComIpcLocatorImpl::~HippoComIpcLocatorImpl()
{
}


HippoIpcController *
HippoComIpcLocatorImpl::getController(const char *serverName)
{
    HippoThreadExecutor *executor = HippoComIpcHub::getInstance()->getExecutor();
    return executor->callSyncR(this, &HippoComIpcLocatorImpl::doGetController, serverName);
}

void 
HippoComIpcLocatorImpl::releaseController(HippoIpcController *controller)
{
    HippoThreadExecutor *executor = HippoComIpcHub::getInstance()->getExecutor();
    executor->callSync(this, &HippoComIpcLocatorImpl::doReleaseController, controller);
}

HippoIpcController *
HippoComIpcLocatorImpl::createController(const char *serverName)
{   
    HippoComIpcProvider *provider = HippoComIpcProvider::createInstance(serverName);
    HippoIpcController *controller = HippoBridgedIpcController::createInstance(provider);
    provider->unref();

    return controller;
}

HippoIpcController *
HippoComIpcLocatorImpl::doGetController(const char *serverName)
{
    return HippoIpcLocator::getController(serverName);
}

void 
HippoComIpcLocatorImpl::doReleaseController(HippoIpcController *controller)
{
    HippoIpcLocator::releaseController(controller);
}
