#ifndef PORTAPIFACTORY_H
#define PORTAPIFACTORY_H

#include "api/portapi.h"
#include "api/lpt/lptapi.h"
#include "api/lpt/lptunixapi.h"
#include "api/lpt/lptwindowsapi.h"

class PortApiFactory {

private:
    PortApi *portApi;

public:
    explicit PortApiFactory() { /*default constructor*/ }

    PortApi *getPortApi() {
        if (!portApi) {

        // select system specific API
        #ifdef Q_OS_WIN32 || Q_OS_WIN64
            portApi = (PortApi *) new LptWindowsApi();
        #else
            portApi = (PortApi *) new LptUnixApi();
        #endif

        }
        return portApi;
    }

};

#endif // PORTAPIFACTORY_H
