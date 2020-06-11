#ifndef STANDARDHANDLERS_H
#define STANDARDHANDLERS_H

#include "IQTestableClassHandler.h"

namespace QTestable
{
  class StandardHandlers
  {
    public:
      static IQTestableClassHandler *buttonHandler();
      static IQTestableClassHandler *applicationHandler();
      static IQTestableClassHandler *labelHandler();
      static IQTestableClassHandler *menuBarHandler();
      static IQTestableClassHandler *menuHandler();
      static IQTestableClassHandler *mainWindowHandler();
      //NEXTHANDLERHERE
  };
}

#endif
