/*
 * BaseLocator
 *
 * Author: Patrick O'Leary
 * Created: October 17, 2010
 * Copyright: 2010. All rights reserved.
 */

#ifndef BASELOCATOR_H_
#define BASELOCATOR_H_

/* Vrui includes */
#include <Vrui/LocatorToolAdapter.h>

// begin Forward Declarations
namespace Vrui {
class LocatorTool;
}
class Pointe_Samhlaigh;
// end Forward Declarations
class BaseLocator: public Vrui::LocatorToolAdapter {
public:
    BaseLocator(Vrui::LocatorTool* _locatorTool, Pointe_Samhlaigh* _pointe_samhlaigh);
    ~BaseLocator();
    virtual void highlightLocator(GLContextData& contextData) const;
    virtual void glRenderAction(GLContextData& contextData) const;
    virtual void glRenderActionTransparent(GLContextData& contextData) const;
private:
    Pointe_Samhlaigh* pointe_samhlaigh;
};

#endif /* BASELOCATOR_H_ */
