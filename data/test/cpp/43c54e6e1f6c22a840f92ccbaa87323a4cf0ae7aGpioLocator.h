/*
 * GpioLocator.h -- Gpio mount locator
 *
 * (c) 2014 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#ifndef _GpioLocator_h
#define _GpioLocator_h

#include <AstroLocator.h>
#include <AstroDevice.h>

namespace astro {
namespace device {
namespace gpio {

class GpioLocator : public astro::device::DeviceLocator {
public:
	GpioLocator();
	virtual ~GpioLocator();
	virtual std::string	getName() const;
	virtual std::string	getVersion() const;
	virtual std::vector<std::string>	getDevicelist(
		DeviceName::device_type device = DeviceName::Guideport);
protected:
	virtual astro::camera::GuidePortPtr	getGuidePort0(const DeviceName& name);
};

} // namespace gpio
} // namespace device
} // namespace astro

#endif /* _GpioLocator_h */
