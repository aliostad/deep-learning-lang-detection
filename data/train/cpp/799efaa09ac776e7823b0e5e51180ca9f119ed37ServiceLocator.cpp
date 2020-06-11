#include "ServiceLocator.hpp"

#include "IService.hpp"

#include <boost/format.hpp>
#include <boost/make_shared.hpp>
#include <boost/thread/lock_guard.hpp>
#include <boost/uuid/uuid_io.hpp>

#include <string>


namespace aw {
namespace core {
namespace base {

boost::mutex ServiceLocator::m_mutex;
boost::weak_ptr<ServiceLocator> ServiceLocator::m_weakInstance;

ServiceLocator::ServiceLocator()
: m_services() {
}

ServiceLocator::~ServiceLocator() {
}

ServiceLocatorPtr ServiceLocator::Instance() {

    boost::lock_guard<boost::mutex> guard(m_mutex);

    ServiceLocatorPtr serviceLocator = m_weakInstance.lock();

    if(serviceLocator) {
        return serviceLocator;
    }

    // Service-locator not there yet, so create it.
    serviceLocator = ServiceLocatorPtr(new ServiceLocator());
    m_weakInstance = serviceLocator;
    return serviceLocator;
}

void ServiceLocator::RegisterService(IServicePtr service) {

    if(!service) {
        throw std::invalid_argument("Invalid service to register.");
    }

    boost::lock_guard<boost::mutex> guard(m_mutex);

    if(!m_services.insert(std::make_pair(service->GetServiceID(), service)).second) {
        throw std::exception(boost::str(boost::format("Service (%1%) already registered.")
            % boost::uuids::to_string(service->GetServiceID())).c_str());
    }
}

IServicePtr ServiceLocator::GetService(const base::UUID& serviceID) const {

    boost::lock_guard<boost::mutex> guard(m_mutex);

    boost::unordered_map<base::UUID, IServicePtr>::const_iterator findIter = m_services.find(serviceID);
    if(findIter == m_services.end()) {

        throw std::exception(boost::str(boost::format("No service registered matching the ID (%1%).")
            % boost::uuids::to_string(serviceID)).c_str());
    }

    return findIter->second;
}


} // namespace base
} // namespace core
} // namespace aw