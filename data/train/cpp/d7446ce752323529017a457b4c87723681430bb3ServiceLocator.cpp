
#include "ServiceLocator.h"
#include "Server.h"
#include <cstring>
#include <sys/socket.h>


__thread ServiceLocator* ServiceLocator::locator;

ServiceLocator::ServiceLocator() : connection(nullptr), server(nullptr) {
    locator = NULL;
}

ServiceLocator::~ServiceLocator() {
}

void ServiceLocator::setAsServiceLocator() {
    locator = this;
}

void ServiceLocator::setServer(Server* s) {
    server = s;
}

void ServiceLocator::setDBConnection(DBConnection* dbc) {
    connection = dbc;
}

void ServiceLocator::setClientSocketHandle(int handle) {
    clientHandle = handle;
}

DBConnection* ServiceLocator::getDBConnection() {
    return connection;
}

void ServiceLocator::sendMessageToClient(const char* message) {
    sendMessageToClient(message, strlen(message));
}

void ServiceLocator::sendMessageToClient(const char* message, int length) {
    send(clientHandle, message, length, 0);
}

void ServiceLocator::stopServer() {
    server->stopServer();
}

ImmutableServiceLocator& ServiceLocator::getServiceLocator() {
    return *locator;
}
