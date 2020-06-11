#include "server_handler.h"
#include "rpc_global.h"
#include "server_controller.h"
#include "server_rpc_protocol.h"

AbstractHandlerFactory* ServerHandlerFactory::s_instance = 0;

ServerHandlerFactory::ServerHandlerFactory(){
}

bool ServerHandlerFactory::addPair(HandlerType request, HandlerType response, Controller* controller) {

    Handler* req = createRequest(request,controller);
    Handler* resp = createResponse(response,controller);

    if (req && resp) {
        controller->protocol()->addMapping(req,resp);
        controller->protocol()->setHandlerTypeTohandlerMapping(request,req);
        controller->protocol()->setHandlerTypeTohandlerMapping(response,resp);
        return true;
    }
    return false;
}


Handler* ServerHandlerFactory::createRequest(HandlerType type, Controller* controller) {

    Handler* handler = 0;
    switch (type) {
    case _REQUEST_LINK_: {
        handler = new ServerLinkRequestHandler(controller);
    }break;
    case _CALL_METHOD_: {
        handler = new ServerMethodCallRequestHandler(controller);
    }break;
    case _REQUEST_DISCONNECT_: {
        handler = new ServerDisconnectRequestHandler(controller);
    }break;
    case _SIGNAL_FORWARD_: {
        handler = new ServerSignalForwardRequestHandler(controller);
    }break;
    case _SIGNAL_CONNECT_: {
        handler = new ServerSignalConnectionRequestHandler(controller);
    }break;

    }
    return handler;
}
Handler* ServerHandlerFactory::createResponse(HandlerType type, Controller* controller) {

    Handler* handler = 0;
    switch (type) {
    case _CONFIRM_LINK_: {
        handler = new ServerLinkConfirmationHandler(controller);
    }break;
    case _RETURN_FROM_CALL_: {
        handler = new ServerMethodCallConfirmationHandler(controller);
    }break;
    case _CONFIRM_DISCONNECT_: {
        handler = new ServerDisconnectConfirmationHandler(controller);
    }break;
    case _SIGNAL_CONF_: {
        handler = new ServerSignalForwardConfirmationHandler(controller);
    }break;
    case _SIGNAL_CONF_CONN_: {
        handler = new ServerSignalConnectionConfirmationHandler(controller);
    }break;
    }
    return handler;
}

