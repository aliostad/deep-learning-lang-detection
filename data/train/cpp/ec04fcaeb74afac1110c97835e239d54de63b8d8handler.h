#ifndef _MINOTAUR_HANDLER_SKELETON_H_
#define _MINOTAUR_HANDLER_SKELETON_H_
/**
 * @file handler_skeleton.h
 * @author Wolfhead
 */
#include "stage.h"

namespace ade {

class IOService;

class Handler {
 public:
  enum {
    kUnspecifiedId = 0xFFFF,
  };

  Handler() : io_service_(NULL) {}
  Handler(const Handler& handler);
  Handler& operator= (const Handler& handler);

  virtual ~Handler() {}

  void SetIOService(IOService* service) {io_service_ = service;}
  IOService* GetIOService() const {return io_service_;}

  void SetHandlerId(uint32_t handler_id) {handler_id_ = handler_id;}
  uint16_t GetHandlerId() const {return handler_id_;}

 private:
  uint16_t handler_id_;
  IOService* io_service_;
};

} //namespace ade

#endif // _MINOTAUR_HANDLER_SKELETON_H_
