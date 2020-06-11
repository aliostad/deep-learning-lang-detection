
#include "SystemCommandDelegate.h"
#include "ServiceLocator.h"
#include "DBUtil.h"

void SystemCommandDelegate::interpretCommand(char* bytes, int length) {
    if(length <= 1) {
        return;
    }
    
    switch(bytes[1]) {
        case 0x01 : 
            ServiceLocator::getServiceLocator().sendMessageToClient("Stopping server.\n");
            ServiceLocator::getServiceLocator().stopServer();
            break;
        case 0x02 :
            DBUtil::runSQLFromFile(SCHEME_FILE);
            ServiceLocator::getServiceLocator().sendMessageToClient("Scheme Loaded.\n");
            break;
        case 0x03 :
            DBUtil::runSQLFromFile(SCHEME_PURGE_FILE);
            ServiceLocator::getServiceLocator().sendMessageToClient("Database purged.\nd");
            break;
        default :
            ServiceLocator::getServiceLocator().sendMessageToClient("Unrecognized system command.\n");
            break;
    }
}
