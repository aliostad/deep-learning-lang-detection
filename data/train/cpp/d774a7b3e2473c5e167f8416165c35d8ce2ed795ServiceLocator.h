/* 
 * File:   ServiceLocator.h
 * Author: toddgreener
 *
 * Created on May 27, 2014, 7:35 PM
 */

#ifndef SERVICELOCATOR_H
#define	SERVICELOCATOR_H

#include "DBConnection.h"
#include "ImmutableServiceLocator.h"
#include <stdlib.h>

class Server;

class ServiceLocator :  public ImmutableServiceLocator {
private:
    DBConnection* connection;
    Server* server;
    int clientHandle;
    static __thread ServiceLocator* locator;
    
public:
    ServiceLocator();
    ~ServiceLocator();
    
    static ImmutableServiceLocator& getServiceLocator();
    
    virtual DBConnection* getDBConnection() override;
    virtual void sendMessageToClient(const char* message) override;
    virtual void sendMessageToClient(const char* message, int length) override;
    virtual void stopServer() override;
   
    void setDBConnection(DBConnection* dbc);
    void setClientSocketHandle(int handle);
    void setAsServiceLocator();
    void setServer(Server* s);
};

#endif	/* SERVICELOCATOR_H */

