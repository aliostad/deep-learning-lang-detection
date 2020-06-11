#ifndef XCE_ARCH_CONFIGSERVER_ADAPTER_H__
#define XCE_ARCH_CONFIGSERVER_ADAPTER_H__

#include "arch/adapter.h"
#include "arch/configserver.h"

namespace xce {

typedef ClientPtr<ConfigServerPrx, RegistryLocator, TWO_WAY> ConfigServerAdapter;

inline ConfigServerAdapter CachedConfigServer() {
  static ConfigServerAdapter p_(
    //RegistryLocator(RegistryLocator::Default())
    RegistryLocator(RegistryLocator::Default()), "config_server:tcp -h 10.2.17.61 -p 21000");
    //RegistryLocator(RegistryLocator::search_cache()), "config_server@ConfigServer1");
  return p_;
}

}

#endif // XCE_ARCH_CONFIGSERVER_ADAPTER_H__
