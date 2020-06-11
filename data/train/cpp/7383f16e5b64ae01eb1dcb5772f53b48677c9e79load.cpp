#include "load.h"

/* code_generator includes */
#include "../location_includes.h"

namespace In {

Load::Ptr
Load::LoadNew(Location::Ptr _src, Location::Ptr _dst) {
  return new Load(_src, _dst);
}

Load::Load(Location::Ptr _src, Location::Ptr _dst) : 
  src_(_src), dst_(_dst)
{
  assert(src_);
  assert(dst_);
}

Location::Ptr
Load::src() {
  return src_;
}

Location::Ptr
Load::src() const {
  return src_;
}

Location::Ptr
Load::dst() {
  return dst_;
}

Location::Ptr
Load::dst() const {
  return dst_;
}

} /* end of namespace In */
