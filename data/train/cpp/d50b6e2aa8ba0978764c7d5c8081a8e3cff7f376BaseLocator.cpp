/*
 * BaseLocator.cpp - Methods for BaseLocator class.
 * 
 * Author: Patrick O'Leary
 * Created: February 8, 2008
 * Copyright 2008. All rights reserved.
 */

/* Vrui includes */
#include <Vrui/Tools/LocatorTool.h>

#include <ANALYSIS/BaseLocator.h>
#include <Toirt_Samhlaigh.h>

/*
 * BaseLocator
 * 
 * parameter _locatorTool - Vrui::LocatorTool*
 * parameter _application - Toirt_Samhlaigh*
 */
BaseLocator::BaseLocator(Vrui::LocatorTool* _locatorTool, Toirt_Samhlaigh* _application) :
	Vrui::LocatorToolAdapter(_locatorTool) {
	application = _application;
} // end BaseLocator()

/*
 * ~BaseLocator - Destructor
 */
BaseLocator::~BaseLocator(void) {
	application = 0;
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
