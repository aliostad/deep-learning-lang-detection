/*
 * UnicapCameraLocator.cpp --
 *
 * (c) 2013 Prof Dr Andreas Mueller, Hochschule Rapperswil
 */
#include <UnicapLocator.h>
#include <includes.h>

using namespace astro::camera::unicap;
using namespace astro::device;

UnicapCameraLocator::UnicapCameraLocator() {
}

UnicapCameraLocator::~UnicapCameraLocator() {
}

std::string	UnicapCameraLocator::getName() const {
	return std::string("unicap");
}

std::string	UnicapCameraLocator::getVersion() const {
	return VERSION;
}

std::vector<std::string>	UnicapCameraLocator::getDevicelist(DeviceLocator::device_type device) {
	std::vector<std::string>	cameras;
	if (DeviceLacator::CAMERA != device) {
		return cameras;
	}
	return cameras;
}

CameraPtr	UnicapCameraLocator::getCamera0(const std::string& name) {
	return CameraPtr();
}
