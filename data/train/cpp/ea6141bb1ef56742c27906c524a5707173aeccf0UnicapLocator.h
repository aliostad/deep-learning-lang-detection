/*
 * UnicapLocator.h -- declarations of the camera 
 *
 * (c) 2013 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#ifndef _UnicapLocator_h
#define _UnicapLocator_h

#include <AstroCamera.h>
#include <AstroDevice.h>

using namespace astro::camera;
using namespace astro::device;

namespace astro {
namespace camera {
namespace unicap {

/**
 * \brief The Unicap camera locator
 *
 * Each Unicap camera is also a camera from the point of view of this 
 */
class UnicapCameraLocator : public DeviceLocator {
public:
	UnicapCameraLocator();
	virtual ~UnicapCameraLocator();
	virtual std::string	getName() const;
	virtual std::vector<std::string>	getDevicelist(DeviceLocator::device_type device = DeviceLocator::CAMERA);
protected:
	virtual CameraPtr	getCamera0(const std::string& name);
public:
	virtual std::string	getVersion() const;
};

} // namespace unicap
} // namespace camera
} // namespace astro

#endif /* _UnicapLocator_h */
