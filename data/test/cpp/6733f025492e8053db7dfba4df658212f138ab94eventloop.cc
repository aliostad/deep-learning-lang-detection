#include <iostream>
#include "eventloop.h"
#include "handler.h"


void EventLoop::Loop() {
  while (!stopping_) {
    std::cout << "Looping......" << std::endl;
    epoller_.GetActiveHandler(&actives_, -1);
    for (int i = 0; i < actives_.size(); i++) {
      if (actives_[i]->callback_)
        (*(actives_[i]->callback_))(actives_[i], actives_[i]->active_events_);
    }
  }
}

void EventLoop::UpdateHandler(Handler * handler) {
  epoller_.UpdateHandler(handler);
}

void EventLoop::AddHandler(Handler * handler) {
  epoller_.AddHandler(handler);
}
void EventLoop::RemoveHandler(Handler * handler) {
  epoller_.RemoveHandler(handler);
}
