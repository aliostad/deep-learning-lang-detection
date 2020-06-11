#include <Vrui/LocatorTool.h>

#include "BaseLocator.h"
#include "ExampleVTKReader.h"

/*
 * BaseLocator
 *
 * parameter _locatorTool - Vrui::LocatorTool*
 * parameter _application - ExampleVTKReader*
 */
BaseLocator::BaseLocator(Vrui::LocatorTool* _locatorTool, ExampleVTKReader* _application) :
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

void BaseLocator::getName(std::string& name) const {
}
