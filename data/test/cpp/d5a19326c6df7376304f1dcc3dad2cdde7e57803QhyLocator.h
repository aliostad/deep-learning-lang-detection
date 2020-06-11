/*
 * QhyLocator.h
 *
 * (c) 2013 Prof Dr Andreas Mueller, QSI camera locator
 */
#ifndef _QhyLocator_h
#define _QhyLocator_h

#include <AstroLocator.h>
#include <AstroCamera.h>
#include <AstroUSB.h>

using namespace astro::device;

namespace astro {
namespace camera {
namespace qhy {

/**
 * \brief The Locator class for QSI devices
 *
 * This is essentially a wrapper about the QSI repository functions
 */
class QhyCameraLocator : public DeviceLocator {
	usb::Context	context;
public:
	QhyCameraLocator();
	virtual ~QhyCameraLocator();
	virtual std::string	getName() const;
	virtual std::string	getVersion() const;
	virtual std::vector<std::string>	getDevicelist(DeviceName::device_type device = DeviceName::Camera);
protected:
	virtual CameraPtr	getCamera0(const DeviceName& name);
	virtual CoolerPtr	getCooler0(const DeviceName& name);
	virtual CcdPtr	getCcd0(const DeviceName& name);
	virtual GuidePortPtr	getGuidePort0(const DeviceName& name);
};

} // namespace qhy
} // namespace camera
} // namespace astro

#endif /* _QhyLocator_h */
