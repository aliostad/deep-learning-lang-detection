#include "WProgram.h"
#include "Event.h"
#include "EventRepo.h"

EventRepo::EventRepo() {
  // Initialize our array lengths  
  _event_types_count = 0;
  _handlers_count = 0;
  
  register_type(EventRepo::REGISTER_EVENT_TYPE);
  register_type(EventRepo::UNREGISTER_EVENT_TYPE);
}

EventRepo::~EventRepo() {

}

boolean EventRepo::register_type(int type) {
  if (_event_types_count == MAX_EVENT_TYPES)
    return false;
  
  _event_types[_event_types_count] = type;
  _event_types_count += 1;
  return true;
}

boolean EventRepo::unregister_type(int type) {
  return false; // TODO
}

boolean EventRepo::bind_handler(int type, event_handler *handler) {
    
}

boolean EventRepo::unbind_handler(int type, event_handler *handler) {
}

boolean EventRepo::push_event(Event::Event *evt) {
}

boolean EventRepo::pop_event(Event::Event *evt) {
}

