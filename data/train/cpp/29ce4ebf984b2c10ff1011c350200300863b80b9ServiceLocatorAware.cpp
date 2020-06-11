#include "ServiceLocatorAware.hpp"

namespace Medit
{
namespace MeditBase
{
namespace DI
{


ServiceLocator *ServiceLocatorAware::getServiceLocator() const
{
    return serviceLocator;
}

void ServiceLocatorAware::setServiceLocator(ServiceLocator *value)
{
    serviceLocator = value;
}

ServiceLocatorAware &ServiceLocatorAware::operator =(const ServiceLocatorAware &original)
{
    serviceLocator = original.serviceLocator;

    return *this;
}
ServiceLocatorAware::ServiceLocatorAware()
{
    serviceLocator = 0x0;
}

ServiceLocatorAware::ServiceLocatorAware(ServiceLocator *locator)
{
    serviceLocator = locator;
}

ServiceLocatorAware::ServiceLocatorAware(const ServiceLocatorAware &original)
{
    serviceLocator = original.serviceLocator;
}

ServiceLocatorAware::~ServiceLocatorAware()
{

}

} // namespace DI
} // namespace MeditBase
} // namespace Medit
