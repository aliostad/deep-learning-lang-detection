//-------------------------------------------------------------------
//  Base Objects for Service Solutions (BOSS)
//  www.t-boss.ru
//
//  Created:     01.03.2014
//  mail:        boss@t-boss.ru
//
//  Copyright (C) 2014 t-Boss 
//-------------------------------------------------------------------

#ifndef __BOSS_PLUGIN_SERVICE_LOCATOR_IDS_H__
#define __BOSS_PLUGIN_SERVICE_LOCATOR_IDS_H__

#include "core/utils.h"

namespace Boss
{
  
  namespace Service
  {
    
    namespace Locator
    {

      namespace Id
      {
        
        enum
        {
          ClassFactoryService = 0x16D1A76D  // CRC32(Boss.Locator.ClassFactory)
        };
        
      }
      
    }
    
  }
  
}

#endif  // !__BOSS_PLUGIN_SERVICE_LOCATOR_IDS_H__
