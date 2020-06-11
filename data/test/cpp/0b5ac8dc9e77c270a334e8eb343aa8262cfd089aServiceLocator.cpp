#include "ServiceLocator.hpp"
#include "AbstractServiceContainer.hpp"
#include "ServiceLocatorAware.hpp"

namespace Medit
{
namespace MeditBase
{
namespace DI
{

ServiceLocator::ServiceLocator()
{
    parent = 0x0;
}

ServiceLocator::~ServiceLocator()
{
    // destroy all services
    Allocator<AbstractServiceContainer> alloc;

    for (ServiceMap::value_type item : services)
    {
        alloc.destroyAndDeallocate(item.second);
    }
}

bool ServiceLocator::isServiceRegistered(size_t id) const
{
    return services.find(id) != services.end();
}

ServiceLocatorAware *ServiceLocator::get(size_t id)
{
    if (!isServiceRegistered(id))
    {
        if (!parent)
        {
            MEDIT_THROW(ServiceLocatorException, "Service was not found",
                        ServiceLocatorException::SERVICE_NOT_FOUND);
        }

        return parent->get(id);
    }

    return services[id]->getInstance();
}

AbstractServiceContainer *ServiceLocator::getServiceContainer(size_t id)
{
    if (!isServiceRegistered(id))
    {
        if (parent)
        {
            return parent->getServiceContainer(id);
        }

        return 0x0;
    }

    return services[id];
}

const AbstractServiceContainer *ServiceLocator::getServiceContainer(size_t id) const
{
    if (!isServiceRegistered(id))
    {
        if (parent)
        {
            return parent->getServiceContainer(id);
        }

        return 0x0;
    }

    return services.find(id)->second;
}

bool ServiceLocator::hasService(size_t id) const
{
    return isServiceRegistered(id) || (parent != 0x0 && parent->hasService(id));
}

void ServiceLocator::registerService(size_t id, AbstractServiceContainer *container)
{
    unregisterService(id);

    services[id] = container;
}

void ServiceLocator::unregisterService(size_t id)
{
    ServiceMap::iterator pos = services.find(id);

    if (pos != services.end())
    {
        services.erase(pos);
    }
}

ServiceLocator::ServiceMap ServiceLocator::getRegisteredServices() const
{
    return services;
}

ServiceLocator *ServiceLocator::getParent() const
{
    return parent;
}

void ServiceLocator::setParent(ServiceLocator *value)
{
    parent = value;
}

ServiceLocator::ServiceLocator(ServiceLocator *parent)
{
    this->parent = parent;
}

} // namespace DI
}


// namespace MeditBase
} // namespace Medit
