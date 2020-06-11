/*
 * DeviceLocator_impl.h -- DeviceLocator Corba interface
 *
 * (c) 2013 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#ifndef _DeviceLocator_impl_h
#define _DeviceLocator_impl_h

#include <module.hh>
#include <AstroLoader.h>
#include <AstroDevice.h>

namespace Astro {

/**
 * \brief DeviceLocator servant definition
 */
class DeviceLocator_impl : public POA_Astro::DeviceLocator {
	astro::device::DeviceLocatorPtr	_locator;
public:
	inline DeviceLocator_impl(astro::device::DeviceLocatorPtr locator)
		: _locator(locator) { }
	virtual ~DeviceLocator_impl() { }
	virtual char	*getName();
	virtual char	*getVersion();
	virtual ::Astro::DeviceLocator::DeviceNameList	*getDevicelist(
				::Astro::DeviceLocator::device_type devicetype);
	virtual Camera_ptr	getCamera(const char *name);
	virtual Ccd_ptr		getCcd(const char *name);
	virtual GuiderPort_ptr	getGuiderPort(const char *name);
	virtual FilterWheel_ptr	getFilterWheel(const char *name);
	virtual	Cooler_ptr	getCooler(const char *name);
	virtual	Focuser_ptr	getFocuser(const char *name);
};

} // namespace Astro

#endif /* _DeviceLocator_impl_h */
