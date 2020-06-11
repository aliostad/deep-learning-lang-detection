/*
 * ClippingPlaneLocator.cpp - Class
 *
 * Author: Patrick O'Leary
 * Created: May 27, 2008
 * Copyright: 2008. All rights reserved.
 */
#ifndef CLIPPINGPLANELOCATOR_H_
#define CLIPPINGPLANELOCATOR_H_

#include <ANALYSIS/BaseLocator.h>
#include <Toirt_Samhlaigh.h>

/* Vrui includes */
#include <Vrui/Tools/LocatorTool.h>

// Begin forward declarations
class ClippingPlane;
// End forward declarations
class ClippingPlaneLocator : public BaseLocator {
public:
	ClippingPlaneLocator(Vrui::LocatorTool* locatorTool,
			Toirt_Samhlaigh * toirt_Samhlaigh);
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
