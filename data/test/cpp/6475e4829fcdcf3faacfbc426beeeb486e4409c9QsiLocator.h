/*
 * QsiLocator.h
 *
 * (c) 2013 Prof Dr Andreas Mueller, QSI camera locator
 */
#ifndef _QsiLocator_h
#define _QsiLocator_h

#include <AstroLocator.h>
#include <AstroCamera.h>

using namespace astro::device;

namespace astro {
namespace camera {
namespace qsi {

/**
 * \brief The Locator class for QSI devices
 *
 * This is essentially a wrapper about the QSI repository functions
 */
class QsiCameraLocator : public DeviceLocator {
	std::string	name(const std::string& serial,
				DeviceName::device_type device);
public:
	QsiCameraLocator();
	virtual ~QsiCameraLocator();
	virtual std::string	getName() const;
	virtual std::string	getVersion() const;
	virtual std::vector<std::string>	getDevicelist(DeviceName::device_type device = DeviceName::Camera);
protected:
	virtual CameraPtr	getCamera0(const DeviceName& name);
	virtual CcdPtr	getCcd0(const DeviceName& name);
	virtual CoolerPtr	getCooler0(const DeviceName& name);
	virtual FilterWheelPtr	getFilterWheel0(const DeviceName& name);
	virtual GuidePortPtr	getGuidePort0(const DeviceName& name);
};

} // namespace qsi
} // namespace camera
} // namespace astro

#endif /* _QsiLocator_h */
