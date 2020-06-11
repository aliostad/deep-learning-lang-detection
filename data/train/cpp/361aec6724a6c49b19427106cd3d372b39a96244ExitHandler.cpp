#include "ExitHandler.h"
#include <cstdlib>
#include <signal.h>

extern "C" void signal_handler(int s) {
  ExitHandler::i()->handle(s);
}

ExitHandler* ExitHandler::inst;

ExitHandler* ExitHandler::i() {
  if(inst == NULL) {
    inst = new ExitHandler();
  }
  return inst;
}

void ExitHandler::setHandler(function<void(int)> h) {
  this->handler = h;

  struct sigaction sigIntHandler;

  sigIntHandler.sa_handler = signal_handler;
  sigemptyset(&sigIntHandler.sa_mask);
  sigIntHandler.sa_flags = 0;

  sigaction(SIGINT, &sigIntHandler, NULL);
}

void ExitHandler::handle(int s) {
  this->handler(s);
}
