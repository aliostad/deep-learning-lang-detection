#ifndef _MINOTAUR_HANDLER_FACTORY_H_
#define _MINOTAUR_HANDLER_FACTORY_H_
/**
 * @file handler_factory.h
 * @author Wolfhead
 */

#include "handler.h"

namespace ade {

class HandlerFactory {
 public:
  HandlerFactory(IOService* io_service) 
      : io_service_(io_service) {
  }

  virtual Handler* Create() = 0;
  IOService* GetIOService() {return io_service_;}
 private:
  IOService* io_service_;
};

template<typename HandlerType>
class GenericHandlerFactory : public HandlerFactory {
 public:
  GenericHandlerFactory(IOService* io_service)
    : HandlerFactory(io_service) {
  }

  virtual Handler* Create() {
    Handler* handler = new HandlerType();
    handler->SetIOService(GetIOService());
    return handler;
  } 
}


} //namespace ade

#endif //_MINOTAUR_HANDLER_FACTORY_H_
