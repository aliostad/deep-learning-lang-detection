#ifndef SIGNALHANDLER_H_
#define SIGNALHANDLER_H_

#include <signal.h>
#include <stdio.h>
#include <memory.h>

#include "event_handler.h"

class SignalHandler {

private:
    static SignalHandler *instance;
    static EventHandler *handlers[NSIG];

    SignalHandler(void);

    static void dispatcher(int signal_number);

public:
    static SignalHandler *get_instance();

    static void destroy();

    EventHandler *register_handler(int signal_number, EventHandler *handler);

    int remove_handler(int signal_number);

};

#endif /* SIGNALHANDLER_H_ */
