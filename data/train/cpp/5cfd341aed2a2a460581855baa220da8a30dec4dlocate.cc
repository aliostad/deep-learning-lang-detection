#include "mccomposite/geometry/locate.h"
#include "journal/debug.h"
#include "mccomposite/geometry/shape2ostream.h"

mccomposite::geometry::Locator::Location 
mccomposite::geometry::locate
( const mccomposite::geometry::Position & position, 
  const mccomposite::geometry::AbstractShape & shape )
{
  mccomposite::geometry::Locator locator;
  locator.setPoint( position );
  Locator::Location location = locator.locate( shape );
#ifdef DEBUG
  journal::debug_t debug("mccomposite.geometry.Locator");
  debug << journal::at(__HERE__)
	<< "location of " << position << " relative to " << shape
	<< " is " << location
	<< journal::endl;
#endif
  return location;
}
