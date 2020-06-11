/*
 * ClippingPlaneLocator.cpp - Methods for the ClippingPlaneLocator class
 *
 * Author: Patrick O'Leary
 * Created: May 27, 2008
 * Copyright: 2008. All rights reserved.
 */
#include <iostream>

/* Vrui includes */
#include <Vrui/Tools/LocatorTool.h>
#include <Geometry/Point.h>
#include <Geometry/Vector.h>
#include <Geometry/OrthogonalTransformation.h>

#include <ANALYSIS/BaseLocator.h>
#include <ANALYSIS/ClippingPlane.h>
#include <ANALYSIS/ClippingPlaneLocator.h>
#include <Toirt_Samhlaigh.h>

/*
 * ClippingPlaneLocator - Constructor for ClippingPlaneLocator class.
 *
 * parameter locatorTool - Vrui::LocatorTool *
 * parameter toirt_Samhlaigh - Toirt_Samhlaigh *
 */
ClippingPlaneLocator::ClippingPlaneLocator(Vrui::LocatorTool * locatorTool,
		Toirt_Samhlaigh* toirt_Samhlaigh) :
	BaseLocator(locatorTool, toirt_Samhlaigh), clippingPlane(0) {
	/* Find a clipping plane index for this locator: */
	ClippingPlane * clippingPlanes = toirt_Samhlaigh->getClippingPlanes();
	for (int i=0; i<toirt_Samhlaigh->getNumberOfClippingPlanes(); ++i)
		if (!clippingPlanes[i].isAllocated()) {
			clippingPlane=&clippingPlanes[i];
			break;
		}

	/* Allocate the clipping plane: */
	if (clippingPlane!=0) {
		clippingPlane->setActive(false);
		clippingPlane->setAllocated(true);
	}
} // end ClippingPlaneLocator()

/*
 * ~ClippingPlaneLocator - Destructor for ClippingPlaneLocator class.
 */
ClippingPlaneLocator::~ClippingPlaneLocator(void) {
	if (clippingPlane!=0) {
		clippingPlane->setActive(false);
		clippingPlane->setAllocated(false);
	}
} // end ~ClippingPlaneLocator()

/*
 * motionCallback
 *
 * parameter callbackData - Vrui::LocatorTool::MotionCallbackData *
 */
void ClippingPlaneLocator::motionCallback(
		Vrui::LocatorTool::MotionCallbackData* callbackData) {
	if (clippingPlane!=0&&clippingPlane->isActive()) {
		Vrui::Vector planeNormal=
				callbackData->currentTransformation.transform(Vrui::Vector(0,
						1, 0));
		Vrui::Point planePoint=callbackData->currentTransformation.getOrigin();
		clippingPlane->setPlane(Vrui::Plane(planeNormal, planePoint));
	}
} // end motionCallback()

/*
 * buttonPressCallback
 *
 * parameter callbackData - Vrui::LocatorTool::ButtonPressCallbackData *
 */
void ClippingPlaneLocator::buttonPressCallback(
		Vrui::LocatorTool::ButtonPressCallbackData* callbackData) {
	if (clippingPlane!=0)
		clippingPlane->setActive(true);
} // end buttonPressCallback()

/*
 * buttonReleaseCallback
 *
 * parameter callbackData - Vrui::LocatorTool::ButtonReleaseCallbackData *
 */
void ClippingPlaneLocator::buttonReleaseCallback(
		Vrui::LocatorTool::ButtonReleaseCallbackData* callbackData) {
	if (clippingPlane!=0)
		clippingPlane->setActive(false);
} // end buttonReleaseCallback()

