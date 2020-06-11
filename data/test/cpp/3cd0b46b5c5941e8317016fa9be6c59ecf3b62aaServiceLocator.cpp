

#include "service/ServiceLocator.hpp"
#include "service/IUrlOpener.hpp"
#include <cassert>

ServiceLocator::ServiceLocator() :
_urlOpener(nullptr)
{
}

ServiceLocator::~ServiceLocator()
{
    delete _urlOpener;
}

ServiceLocator& ServiceLocator::get()
{
    static ServiceLocator locator;
    return locator;
}


void ServiceLocator::setUrlOpener(IUrlOpener* opener)
{
    delete _urlOpener;
    _urlOpener = opener;
}

const IUrlOpener& ServiceLocator::getUrlOpener() const
{
    assert(_urlOpener);
    return *_urlOpener;
}
