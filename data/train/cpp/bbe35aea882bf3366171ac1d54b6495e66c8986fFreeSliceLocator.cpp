#include <iostream>

/* Vrui includes */
#include <Vrui/LocatorTool.h>
#include <Geometry/Point.h>
#include <Geometry/Vector.h>
#include <Geometry/OrthogonalTransformation.h>

/* VTK includes */
#include <vtkLight.h>

/* ExampleVTKReader includes */
#include "BaseLocator.h"
#include "FreeSliceLocator.h"
#include "ExampleVTKReader.h"

/*
 * FreeSliceLocator - Constructor for FreeSliceLocator class.
 *
 * parameter locatorTool - Vrui::LocatorTool *
 * parameter ExampleVTKReader - ExampleVTKReader *
 */
FreeSliceLocator::FreeSliceLocator(Vrui::LocatorTool * locatorTool,
  ExampleVTKReader* ExampleVTKReader) :
  BaseLocator(locatorTool, ExampleVTKReader)
{
} // end FreeSliceLocator()

/*
 * ~FreeSliceLocator - Destructor for FreeSliceLocator class.
 */
FreeSliceLocator::~FreeSliceLocator(void) {
} // end ~FreeSliceLocator()

/*
 * motionCallback
 *
 * parameter callbackData - Vrui::LocatorTool::MotionCallbackData *
 */
void FreeSliceLocator::motionCallback(
		Vrui::LocatorTool::MotionCallbackData* callbackData) {
          Vrui::Point position = callbackData->currentTransformation.getOrigin();
          Vrui::Vector planeNormal =
            callbackData->currentTransformation.transform(Vrui::Vector(0,1,0));
          this->application->setFreeSliceOrigin(position.getComponents());
          this->application->setFreeSliceNormal(planeNormal.getComponents());
} // end motionCallback()

/*
 * buttonPressCallback
 *
 * parameter callbackData - Vrui::LocatorTool::ButtonPressCallbackData *
 */
void FreeSliceLocator::buttonPressCallback(
		Vrui::LocatorTool::ButtonPressCallbackData* callbackData)
{
  this->application->setFreeSliceVisibility(true);
} // end buttonPressCallback()

/*
 * buttonReleaseCallback
 *
 * parameter callbackData - Vrui::LocatorTool::ButtonReleaseCallbackData *
 */
void FreeSliceLocator::buttonReleaseCallback(
		Vrui::LocatorTool::ButtonReleaseCallbackData* callbackData)
{
  this->application->setFreeSliceVisibility(false);
} // end buttonReleaseCallback()
