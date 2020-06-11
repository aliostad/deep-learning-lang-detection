/*
 * CelestronLocator.h -- Celestron mount locator
 *
 * (c) 2014 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#ifndef _CelestronLocator_h
#define _CelestronLocator_h

#include <AstroLocator.h>
#include <AstroDevice.h>

namespace astro {
namespace device {
namespace celestron {

class CelestronLocator : public astro::device::DeviceLocator {
public:
	CelestronLocator();
	virtual ~CelestronLocator();
	virtual std::string	getName() const;
	virtual std::string	getVersion() const;
	virtual std::vector<std::string>	getDevicelist(
		DeviceName::device_type device = DeviceName::Mount);
protected:
	virtual astro::device::MountPtr	getMount0(const DeviceName& name);
};

} // namespace celestron
} // namespace device
} // namespace astro

#endif /* _CelestronLocator_h */
