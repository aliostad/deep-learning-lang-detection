/*
 * OthelloLocator.h -- class to search for our own devices
 *
 * (c) 2015 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#ifndef _OthelloLocator_h
#define _OthelloLocator_h

#include <AstroLocator.h>
#include <AstroCamera.h>
#include <AstroUSB.h>

using namespace astro::usb;
using namespace astro::device;

namespace astro {
namespace camera {
namespace othello {

/**
 * \brief The Locator class for Starlight Express devices
 *
 * All Starlight Express devices are USB devices, so this locator is 
 * essentially a wrapper around a USB context which serves as a factory
 * for the Starlight Express USB devices.
 */
class OthelloLocator : public DeviceLocator {
	Context	context;
public:
	OthelloLocator();
	virtual ~OthelloLocator();
	virtual std::string	getName() const;
	virtual std::string	getVersion() const;
	virtual std::vector<std::string>	getDevicelist(DeviceName::device_type device = DeviceName::Camera);
protected:
	virtual GuidePortPtr	getGuidePort0(const DeviceName& name);
	virtual FocuserPtr	getFocuser0(const DeviceName& name);
};

} // namespace othello
} // namespace camera
} // namespace astro

#endif /* _OthelloLocator_h */
