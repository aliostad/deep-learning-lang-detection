/// @file
/// @brief Static Load Strategy implementation
///
///  Copyright (c) 2007 by Spirent Communications Inc.
///  All Rights Reserved.
///
///  This software is confidential and proprietary to Spirent Communications Inc.
///  No part of this software may be reproduced, transmitted, disclosed or used
///  in violation of the Software License Agreement without the expressed
///  written consent of Spirent Communications Inc.
///

#include "StaticLoadStrategy.h"

USING_L4L7_BASE_NS;

///////////////////////////////////////////////////////////////////////////////

StaticLoadStrategy::StaticLoadStrategy(void)
    : mLoad(0)
{
}

///////////////////////////////////////////////////////////////////////////////

void StaticLoadStrategy::Start(ACE_Reactor *reactor, uint32_t hz)
{
}

///////////////////////////////////////////////////////////////////////////////

void StaticLoadStrategy::Stop(void)
{
}

///////////////////////////////////////////////////////////////////////////////
    
void StaticLoadStrategy::SetLoad(int32_t load)
{
    // Update load value
    mLoad = load;

    // Notify user of load change
    this->LoadChangeHook(mLoad);
}

///////////////////////////////////////////////////////////////////////////////
