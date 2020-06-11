#ifndef CLIPPINGPLANELOCATOR_H_
#define CLIPPINGPLANELOCATOR_H_

#include "BaseLocator.h"
#include <Vrui/LocatorTool.h>
#include "GeometryViewer.h"

// Begin forward declarations
class ClippingPlane;
// End forward declarations
class ClippingPlaneLocator : public BaseLocator {
public:
	ClippingPlaneLocator(Vrui::LocatorTool* locatorTool,
			GeometryViewer * _geometryViewer);
	~ClippingPlaneLocator(void);
	virtual void buttonPressCallback(
			Vrui::LocatorTool::ButtonPressCallbackData* callbackData);
	virtual void buttonReleaseCallback(
			Vrui::LocatorTool::ButtonReleaseCallbackData* callbackData);
	virtual void motionCallback(
			Vrui::LocatorTool::MotionCallbackData* callbackData);
private:
	ClippingPlane * clippingPlane;
};

#endif /*CLIPPINGPLANELOCATOR_H_*/
