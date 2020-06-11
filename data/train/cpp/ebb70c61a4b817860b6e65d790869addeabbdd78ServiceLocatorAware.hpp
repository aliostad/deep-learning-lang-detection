#ifndef MEDIT_MEDITBASE_DI_SERVICELOCATORAWARE_HPP
#define MEDIT_MEDITBASE_DI_SERVICELOCATORAWARE_HPP

#include "../Allocator.hpp"

namespace Medit
{
namespace MeditBase
{
namespace DI
{

class ServiceLocator;


class ServiceLocatorAware
{

    /**
     * @brief stored service locator
     */
    ServiceLocator *serviceLocator;

public:

    typedef MeditBase::Allocator<ServiceLocatorAware> Allocator;

    /**
     * @brief create empty instance
     */
    ServiceLocatorAware();

    /**
     * @brief create instance with locator
     * @param locator service locator to set
     */
    ServiceLocatorAware(ServiceLocator *locator);

    /**
     * @brief copytor
     * @param original instance with original data
     */
    ServiceLocatorAware(const ServiceLocatorAware &original);

    /**
     * @brief destructor
     */
    virtual ~ServiceLocatorAware();

    /**
     * @brief return current service locator
     * @return current service locator
     */
    ServiceLocator *getServiceLocator() const;

    /**
     * @brief set new service locator
     * @param value locator to set
     */
    void setServiceLocator(ServiceLocator *value);

    /**
     * @brief assign operator
     * @param original instance with original data
     * @return reference to self
     */
    ServiceLocatorAware &operator =(const ServiceLocatorAware &original);

};

} // namespace DI
} // namespace MeditBase
} // namespace Medit

#endif // MEDIT_MEDITBASE_DI_SERVICELOCATORAWARE_HPP
