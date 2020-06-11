#ifndef EVENTHANDLER_H
#define EVENTHANDLER_H
#include "eventstoreact.h"
#include "HANDLER.h"
class EventHandler{
 protected:
    bool errorflag;
    HANDLER handler;
 public:
    EventHandler():errorflag(false){}
    HANDLER get_handler(){return handler;}
    virtual EventsToReact events_to_react();
    virtual bool delete_this_handler()=0;
    virtual void ready_read(){}
    virtual void ready_write(){}
    virtual void exeption(){}
    virtual void time_out(){}
    virtual ~EventHandler(){handler.close_d();}
};
#endif // EVENTHANDLER_H
