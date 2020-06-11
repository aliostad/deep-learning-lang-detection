#ifndef PROTOCOL_H
#define PROTOCOL_H
#include <QtCore/QHash>

class Handler;
class Packet;
class Controller;
typedef int HandlerType;

#define PAIR   2

struct Protocol {

    virtual void addMapping(Handler*, Handler*) = 0;
    virtual Handler* map(Handler*) = 0;
    virtual HandlerType handlerTypeForHandler(Handler* handler) const = 0;
    virtual Handler* handlerForHandlerType(HandlerType type) const = 0;
    virtual void setHandlerTypeTohandlerMapping(HandlerType, Handler*) = 0;
};

class AbstractProtocolFactory {

public:
    virtual void createProtocol(Controller* controller) = 0;
};

#endif // PROTOCOL_H
