/*
 * BaseLocator.cpp - Methods for BaseLocator class.
 * 
 * Author: Patrick O'Leary
 * Created: June 3, 2010
 * Copyright 2010. All rights reserved.
 */

/* Vrui includes */
#include <Vrui/Tools/LocatorTool.h>

#include <ANALYSIS/BaseLocator.h>
#include <FenwayPark.h>

/*
 * BaseLocator
 * 
 * parameter _locatorTool - Vrui::LocatorTool*
 * parameter _fenwayPark - FenwayPark*
 */
BaseLocator::BaseLocator(Vrui::LocatorTool* _locatorTool, FenwayPark* _fenwayPark) :
	Vrui::LocatorToolAdapter(_locatorTool) {
	fenwayPark = _fenwayPark;
} // end BaseLocator()

/*
 * ~BaseLocator - Destructor
 */
BaseLocator::~BaseLocator(void) {
	fenwayPark = 0;
} // end ~BaseLocator()

/*
 * highlightLocator - Render actual locator
 * 
 * parameter glContextData - GLContextData&
 */
void BaseLocator::highlightLocator(GLContextData& glContextData) const {
} // end highlightLocator()

/*
 * glRenderAction - Render opaque elements of locator
 * 
 * parameter glContextData - GLContextData&
 */
void BaseLocator::glRenderAction(GLContextData& glContextData) const {
} // end glRenderAction()

/*
 * glRenderActionTransparent - Render transparent elements of locator
 * 
 * parameter glContextData - GLContextData&
 */
void BaseLocator::glRenderActionTransparent(GLContextData& glContextData) const {
} // end glRenderActionTransparent()
