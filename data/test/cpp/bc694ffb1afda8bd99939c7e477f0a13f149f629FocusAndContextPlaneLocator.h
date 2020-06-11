/*
 * FocusAndContextPlaneLocator.h - Class
 *
 * Author: Patrick O'Leary
 * Created: October 11, 2008
 * Copyright: 2008. All rights reserved.
 */
#ifndef FOCUSANDCONTEXTPLANELOCATOR_H_
#define FOCUSANDCONTEXTPLANELOCATOR_H_

#include <ANALYSIS/BaseLocator.h>
#include <Toirt_Samhlaigh.h>

/* Vrui includes */
#include <Vrui/Tools/LocatorTool.h>

// Begin forward declarations
class FocusAndContextPlane;
// End forward declarations
class FocusAndContextPlaneLocator : public BaseLocator {
public:
	FocusAndContextPlaneLocator(Vrui::LocatorTool* locatorTool,
			Toirt_Samhlaigh * toirt_Samhlaigh);
	~FocusAndContextPlaneLocator(void);
	virtual void buttonPressCallback(
			Vrui::LocatorTool::ButtonPressCallbackData* callbackData);
	virtual void buttonReleaseCallback(
			Vrui::LocatorTool::ButtonReleaseCallbackData* callbackData);
	virtual void motionCallback(
			Vrui::LocatorTool::MotionCallbackData* callbackData);
private:
	FocusAndContextPlane * focusAndContextPlane;
};

#endif /*FOCUSANDCONTEXTPLANELOCATOR_H_*/
