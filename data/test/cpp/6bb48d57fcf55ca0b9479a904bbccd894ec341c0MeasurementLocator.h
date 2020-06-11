/*
 * MeasurementLocator
 *
 * Author: Patrick O'Leary
 * Created: February 8, 2008
 * Copyright 2008. All rights reserved.
 */

#ifndef MEASUREMENTLOCATOR_H_
#define MEASUREMENTLOCATOR_H_

/* Vrui includes */
#include <Geometry/Point.h>

#include <ANALYSIS/BaseLocator.h>

// begin Forward Declarations
class Toirt_Samhlaigh;
// end Forward Declarations

class MeasurementLocator : public BaseLocator {
public:
	MeasurementLocator(Vrui::LocatorTool* _locatorTool, Toirt_Samhlaigh* _application);
	~MeasurementLocator(void);
	virtual void motionCallback(Vrui::LocatorTool::MotionCallbackData* cbData);
	virtual void buttonPressCallback(Vrui::LocatorTool::ButtonPressCallbackData* cbData);
	virtual void buttonReleaseCallback(Vrui::LocatorTool::ButtonReleaseCallbackData* cbData);
	virtual void highlightLocator(GLContextData& glContextData) const;
private:
	GLMotif::PopupWindow* measurementDialogPopup;
	GLMotif::TextField* startPosition[3];
	GLMotif::TextField* endPosition[3];
	GLMotif::TextField* distance;
	int numberOfPoints;
	Geometry::Point<double,3> startPoint;
	Geometry::Point<double,3> endPoint;
	bool dragging;
};

#endif /*MEASUREMENTLOCATOR_H_*/
