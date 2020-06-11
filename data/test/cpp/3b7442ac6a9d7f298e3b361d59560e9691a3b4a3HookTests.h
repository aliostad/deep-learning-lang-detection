#ifndef HOOKTESTS_H
#define HOOKTESTS_H

#include "API/IBuildResponse.h"
#include "API/INetwork.h"
#include "API/IReceiveRequest.h"
#include "API/ISendResponse.h"
#include "API/IServerEvent.h"
#include "API/IWorkflow.h"
#include "API/IModuleEvent.h"
#include "Modules/AbstractModule.h"

class HookTests : public AbstractModule, public zAPI::IBuildResponse, public zAPI::INetwork, public zAPI::IReceiveRequest, public zAPI::ISendResponse, public zAPI::IServerEvent, public zAPI::IWorkflow, public zAPI::IModuleEvent
{
    public:
        HookTests();
        virtual ~HookTests();

        int                         getPriority(zAPI::IModule::Event) const;

        zAPI::IModule::ChainStatus  onPreBuild(zAPI::IHttpRequest*, zAPI::IHttpResponse*);
        zAPI::IModule::ChainStatus  onPostBuild(zAPI::IHttpRequest*, zAPI::IHttpResponse*);

        zAPI::IClientSocket*        onAccept(SOCKET);
        zAPI::IModule::ChainStatus  onReceive(char*, size_t);
        zAPI::IModule::ChainStatus  onSend(char*, size_t);

        zAPI::IModule::ChainStatus  onPreReceive(zAPI::IHttpRequest*, zAPI::IHttpResponse*);
        zAPI::IModule::ChainStatus  onPostReceive(zAPI::IHttpRequest*, zAPI::IHttpResponse*);

        void                        setInput(zAPI::IModule*);
        zAPI::IModule::ChainStatus  onPreSend(zAPI::IHttpRequest*, zAPI::IHttpResponse*);
        size_t                      onProcessContent(zAPI::IHttpRequest*, zAPI::IHttpResponse*, char*, size_t, IModule**, unsigned int);
        zAPI::IModule::ChainStatus  onPostSend(zAPI::IHttpRequest*, zAPI::IHttpResponse*);

        zAPI::IModule::ChainStatus  onServerStart();
        zAPI::IModule::ChainStatus  onServerStop();

        zAPI::IModule::ChainStatus  onBegin(zAPI::IHttpRequest*, zAPI::IHttpResponse*);
        zAPI::IModule::ChainStatus  onEnd(zAPI::IHttpRequest*, zAPI::IHttpResponse*);
        zAPI::IModule::ChainStatus  onFailure(zAPI::IHttpRequest*, zAPI::IHttpResponse*);

        zAPI::IModule::ChainStatus  onLoadModule(zAPI::IModuleInfo*);
        zAPI::IModule::ChainStatus  onUnloadModule(zAPI::IModuleInfo*);
};

#endif // HOOKTESTS_H
