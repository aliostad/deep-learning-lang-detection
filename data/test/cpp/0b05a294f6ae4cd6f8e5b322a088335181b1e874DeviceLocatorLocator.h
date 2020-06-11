/*
 * DeviceLocatorLocator.h -- locator for DeviceLocator servants
 *
 * (c) 2014 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#ifndef _DeviceLocatorLocator_h
#define _DeviceLocatorLocator_h

#include <Ice/Ice.h>
#include <AstroLoader.h>

namespace snowstar {

class DeviceLocatorLocator : public Ice::ServantLocator {
	astro::module::Repository	_repository;
public:
	DeviceLocatorLocator(astro::module::Repository& repository);
	virtual ~DeviceLocatorLocator();
	virtual Ice::ObjectPtr  locate(const Ice::Current& current,
			Ice::LocalObjectPtr& cookie);
	virtual void    finished(const Ice::Current& current,
				const Ice::ObjectPtr& servant,
				const Ice::LocalObjectPtr& cookie);
	virtual void    deactivate(const std::string& category);
};

} // namespace snowstar

#endif /* _DeviceLocatorLocator_h */
