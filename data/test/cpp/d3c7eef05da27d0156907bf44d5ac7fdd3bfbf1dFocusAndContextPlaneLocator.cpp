/*
 * FocusAndContextPlaneLocator.cpp - Methods for the FocusAndContextPlaneLocator class
 *
 * Author: Patrick O'Leary
 * Created: October 11, 2008
 * Copyright: 2008. All rights reserved.
 */
#include <iostream>

/* Vrui includes */
#include <Vrui/Tools/LocatorTool.h>
#include <Geometry/Point.h>
#include <Geometry/Vector.h>
#include <Geometry/OrthogonalTransformation.h>

#include <ANALYSIS/BaseLocator.h>
#include <ANALYSIS/FocusAndContextPlane.h>
#include <ANALYSIS/FocusAndContextPlaneLocator.h>
#include <Toirt_Samhlaigh.h>

/*
 * FocusAndContextPlaneLocator - Constructor for FocusAndContextPlaneLocator class.
 *
 * parameter locatorTool - Vrui::LocatorTool *
 * parameter toirt_Samhlaigh - Toirt_Samhlaigh *
 */
FocusAndContextPlaneLocator::FocusAndContextPlaneLocator(Vrui::LocatorTool * locatorTool,
		Toirt_Samhlaigh* toirt_Samhlaigh) :
	BaseLocator(locatorTool, toirt_Samhlaigh), focusAndContextPlane(0) {
	/* Find a clipping plane index for this locator: */
	FocusAndContextPlane * focusAndContextPlanes = toirt_Samhlaigh->getFocusAndContextPlanes();
	for (int i=0; i<toirt_Samhlaigh->getNumberOfFocusAndContextPlanes(); ++i)
		if (!focusAndContextPlanes[i].isAllocated()) {
			focusAndContextPlane=&focusAndContextPlanes[i];
			break;
		}

	/* Allocate the clipping plane: */
	if (focusAndContextPlane!=0) {
		focusAndContextPlane->setActive(false);
		focusAndContextPlane->setAllocated(true);
	}
} // end FocusAndContextPlaneLocator()

/*
 * ~FocusAndContextPlaneLocator - Destructor for FocusAndContextPlaneLocator class.
 */
FocusAndContextPlaneLocator::~FocusAndContextPlaneLocator(void) {
	if (focusAndContextPlane!=0) {
		focusAndContextPlane->setActive(false);
		focusAndContextPlane->setAllocated(false);
	}
} // end ~FocusAndContextPlaneLocator()

/*
 * motionCallback
 *
 * parameter callbackData - Vrui::LocatorTool::MotionCallbackData *
 */
void FocusAndContextPlaneLocator::motionCallback(
		Vrui::LocatorTool::MotionCallbackData* callbackData) {
	if (focusAndContextPlane!=0&&focusAndContextPlane->isActive()) {
		Vrui::Vector planeNormal=
				callbackData->currentTransformation.transform(Vrui::Vector(0,
						1, 0));
		Vrui::Point planePoint=callbackData->currentTransformation.getOrigin();
		focusAndContextPlane->setPlane(Vrui::Plane(planeNormal, planePoint));
	}
} // end motionCallback()

/*
 * buttonPressCallback
 *
 * parameter callbackData - Vrui::LocatorTool::ButtonPressCallbackData *
 */
void FocusAndContextPlaneLocator::buttonPressCallback(
		Vrui::LocatorTool::ButtonPressCallbackData* callbackData) {
	if (focusAndContextPlane!=0)
		focusAndContextPlane->setActive(true);
} // end buttonPressCallback()

/*
 * buttonReleaseCallback
 *
 * parameter callbackData - Vrui::LocatorTool::ButtonReleaseCallbackData *
 */
void FocusAndContextPlaneLocator::buttonReleaseCallback(
		Vrui::LocatorTool::ButtonReleaseCallbackData* callbackData) {
	if (focusAndContextPlane!=0)
		focusAndContextPlane->setActive(false);
} // end buttonReleaseCallback()

