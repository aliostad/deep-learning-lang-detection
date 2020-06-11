#include "signal_handler.h"

SignalHandler *SignalHandler::instance = NULL;
EventHandler *SignalHandler::handlers[NSIG];

SignalHandler::SignalHandler() {
}

SignalHandler *SignalHandler::get_instance() {
    if (instance == NULL) {
        instance = new SignalHandler();
    }
    return instance;
}

void SignalHandler::destroy() {
    if (instance != NULL) {
        delete(instance);
        instance = NULL;
    }
}

EventHandler *SignalHandler::register_handler(int signal_number, EventHandler *handler) {
    EventHandler *old_handler = SignalHandler::handlers[signal_number];
    SignalHandler::handlers[signal_number] = handler;

    struct sigaction action;
    memset(&action, 0, sizeof(action));
    action.sa_handler = SignalHandler::dispatcher;
    sigemptyset(
            &action.sa_mask);    // inicializa la mascara de seniales a bloquear durante la ejecucion del handler como vacio
    sigaddset(&action.sa_mask, signal_number);
    sigaction(signal_number, &action, 0);    // cambiar accion de la senial

    return old_handler;
}

void SignalHandler::dispatcher(int signal_number) {
    if (SignalHandler::handlers[signal_number] != 0) {
        SignalHandler::handlers[signal_number]->handle_signal(signal_number);
    }
}

int SignalHandler::remove_handler(int signal_number) {
    SignalHandler::handlers[signal_number] = NULL;
    return 0;
}
