/// @file
/// @brief Bandwidth Load Manager implementation
///
///  Copyright (c) 2009 by Spirent Communications Inc.
///  All Rights Reserved.
///
///  This software is confidential and proprietary to Spirent Communications Inc.
///  No part of this software may be reproduced, transmitted, disclosed or used
///  in violation of the Software License Agreement without the expressed
///  written consent of Spirent Communications Inc.
///

#include <iostream>

#include "BandwidthLoadManager.h"

USING_L4L7_APP_NS;

///////////////////////////////////////////////////////////////////////////////

BandwidthLoadManager::BandwidthLoadManager()
    : mProtoName("-"),
      mBllHnd(0),
      mEnableDynamicLoad(false),
      mEnableBwCtrl(false),
      mDynamicLoadTotal(0),
      mDynamicLoadPerConnBps(0),
      mPrevLoadPerConnBps(0),
      mDynamicLoadInput(0),
      mDynamicLoadOutput(0)
{
    InitBwTimeStorage();
}

///////////////////////////////////////////////////////////////////////////////

BandwidthLoadManager::~BandwidthLoadManager()
{
}

///////////////////////////////////////////////////////////////////////////////

void BandwidthLoadManager::RegisterDynamicLoadDelegates(StreamSocketHandler *ssh)
{
    ssh->RegisterDynamicLoadDelegates(
        boost::bind(&BandwidthLoadManager::GetDynamicLoad, this, _1),
        boost::bind(&BandwidthLoadManager::ProduceDynamicLoad, this, _1, _2),
        boost::bind(&BandwidthLoadManager::ConsumeDynamicLoad, this, _1, _2)
    );
}

///////////////////////////////////////////////////////////////////////////////

void BandwidthLoadManager::UnregisterDynamicLoadDelegates(StreamSocketHandler *ssh)
{
    ssh->UnregisterDynamicLoadDelegates();
}

///////////////////////////////////////////////////////////////////////////////

size_t BandwidthLoadManager::GetDynamicLoad(bool isInput)
{
    if (isInput)
        return mDynamicLoadInput;
    else
        return mDynamicLoadOutput;

    return 0;
}

///////////////////////////////////////////////////////////////////////////////

size_t BandwidthLoadManager::ProduceDynamicLoad(bool isInput, const ACE_Time_Value& currTime)
{
    ACE_Time_Value elapsed;
    time_t secElapsed;

    size_t maxSizeT = (size_t)-1;
    size_t bytesProduced = mDynamicLoadPerConnBps;  // multiplier in If/Else

    if (isInput)
    {
        elapsed = currTime - mLastInput;
        secElapsed = elapsed.sec();
        bytesProduced *= secElapsed;
        if (bytesProduced > 0)
            mLastInput = currTime;

        if ((maxSizeT - mDynamicLoadInput) < bytesProduced) // Cap produced at MAX size_t
            mDynamicLoadInput = maxSizeT;
        else
            mDynamicLoadInput += bytesProduced;

        return mDynamicLoadInput;
    }
    else
    {
        elapsed = currTime - mLastOutput;
        secElapsed = elapsed.sec();
        bytesProduced *= secElapsed;
        if (bytesProduced > 0)
            mLastOutput = currTime;

        if ((maxSizeT - mDynamicLoadOutput) < bytesProduced) // Cap produced at MAX size_t
            mDynamicLoadOutput = maxSizeT;
        else
            mDynamicLoadOutput += bytesProduced;

        return mDynamicLoadOutput;
    }

    return 0;
}

///////////////////////////////////////////////////////////////////////////////

size_t BandwidthLoadManager::ConsumeDynamicLoad(bool isInput, size_t consumed)
{
    if (isInput)
    {
        if (mDynamicLoadInput < consumed) // Prevents bytesNeeded from rolling over
            consumed = mDynamicLoadInput;

        mDynamicLoadInput -= consumed;
        return mDynamicLoadInput;
    }
    else
    {
        if (mDynamicLoadOutput < consumed) // Prevents bytesNeeded from rolling over
            consumed = mDynamicLoadOutput;
            
        mDynamicLoadOutput -= consumed;
        return mDynamicLoadOutput;
    }
  
    return 0;
}

///////////////////////////////////////////////////////////////////////////////

int32_t BandwidthLoadManager::ConfigDynamicLoad(size_t conn, int32_t dynamicLoad)
{
    bool resetClocks = false;

    if (!mEnableBwCtrl)
        return -1;

    if (mDynamicLoadTotal == 0)
        resetClocks = true;

    mDynamicLoadTotal = dynamicLoad;
    
    // split bandwith among open connections
    if (conn != 0 && dynamicLoad != 0)
    {
        dynamicLoad = dynamicLoad / conn;
        if (dynamicLoad == 0)
            dynamicLoad = 1;    // set to lowest acceptable dynamic load
    }

    mDynamicLoadPerConnBps = dynamicLoad * 128;  // convert from kbps to Bps (1024 / 8)

    if (mPrevLoadPerConnBps != mDynamicLoadPerConnBps)
    {
        // Restart Byte Counts if load changed
        mDynamicLoadInput = 0;
        mDynamicLoadOutput = 0;

        mPrevLoadPerConnBps = mDynamicLoadPerConnBps;
    }

    // Restart Clocks: if times building up w/ load at 0, then load is > 0 the byte count will be load*time
    if (resetClocks)
        mLastInput = mLastOutput = ACE_OS::gettimeofday();
    
    return (mDynamicLoadTotal * 1024);  // convert kbps to bps
}

///////////////////////////////////////////////////////////////////////////////
