
#ifndef __ServiceLocator_H__
#define __ServiceLocator_H__

#include "service/ServiceLocator.fwd.hpp"
#include "service/IUrlOpener.fwd.hpp"
 
/**
 * This is the only singleton in the game
 * @see http://gameprogrammingpatterns.com/service-locator.html
 */
class ServiceLocator
{
private:
    IUrlOpener* _urlOpener;
    
    ServiceLocator();
public:

	static ServiceLocator& get();
    ~ServiceLocator();
    
    void setUrlOpener(IUrlOpener* opener);
    const IUrlOpener& getUrlOpener() const;

};

#endif /* defined(__ServiceLocator_H__) */
