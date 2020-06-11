#ifndef _REDIS_REPLICATION_LOCATOR_H_
#define _REDIS_REPLICATION_LOCATOR_H_

#include "stdint.h"
#include <string>
#include <map>
#include <hiredis/hiredis.h>

#include "redis_locator.h"

namespace redis {

class ReplicationLocator : public RedisLocator {
 public:
  ReplicationLocator(const std::string & master_endpoint,
      const std::string & slave_endpoints);

  virtual ~ReplicationLocator(){}

  virtual std::string Locate(const char *);
 private:
  std::string master_endpoint_;
  std::map<std::string, int32_t> slave_endpoints_;
  std::map<int32_t, std::string> weight_section_;
  int32_t total_weight_;
};

}

#endif // _REDIS_REPLICATION_LOCATOR_H_

