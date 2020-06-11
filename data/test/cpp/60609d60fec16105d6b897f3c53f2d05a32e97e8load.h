
#ifndef _System_Interaction_Load_H_
#define _System_Interaction_Load_H_

#include "system/interaction/interface.h"
#include "array/1d/imprint.h"
#include "array/1d/copy.h"

#ifndef _LOAD
#define _LOAD(PART) \
  template <typename T,typename IDT,typename ParamT,typename GeomT,\
            typename BufferT,template<typename> class CT> \
  void Load##PART(SystemInteraction<T,IDT,ParamT,GeomT,BufferT,CT>& SI,\
                  const PART##T& i##PART) { \
    Imprint(SI.PART,i##PART); \
    Copy(SI.PART,i##PART); \
  }
#else
#error "Duplicate Definition for Macro _LOAD"
#endif

#ifndef FuncT
#define FuncT Array1D<InteractionFunc<GeomT,T>
#else
#error "Duplicate Definition for Macro FuncT"
#endif

namespace mysimulator {

  _LOAD(Func)

}

#ifdef FuncT
#undef FuncT
#endif

namespace mysimulator {

  _LOAD(ID)
  _LOAD(Param)
  _LOAD(Geom)
  _LOAD(Buffer)

}

#ifdef _LOAD
#undef _LOAD
#endif

#endif

