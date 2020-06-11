/*
 * BaseLocator.cpp - Methods for BaseLocator class.
 * 
 * Author: Patrick O'Leary
 * Created: June 3, 2010
 * Copyright 2010. All rights reserved.
 */

/* Vrui includes */
#include <Vrui/LocatorTool.h>

#include <ANALYSIS/BaseLocator.h>
#include <Rocket.h>

/*
 * BaseLocator
 * 
 * parameter _locatorTool - Vrui::LocatorTool*
 * parameter _rocket - Rocket*
 */
BaseLocator::BaseLocator(Vrui::LocatorTool* _locatorTool, Rocket* _rocket) :
	Vrui::LocatorToolAdapter(_locatorTool) {
	rocket = _rocket;
} // end BaseLocator()

/*
 * ~BaseLocator - Destructor
 */
BaseLocator::~BaseLocator(void) {
	rocket = 0;
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
