/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "SampleTable"
//#define LOG_NDEBUG 0
#include <utils/Log.h>

#include "include/SampleTable.h"
#include "include/SampleIterator.h"

#include <arpa/inet.h>

#include <media/stagefright/foundation/ADebug.h>
#include <media/stagefright/DataSource.h>
#include <media/stagefright/Utils.h>

using namespace android; 
#include <utils/KeyedVector.h> 
#include <utils/threads.h> 
static KeyedVector<int, SampleTable_mtk*> mtkSampleTableObjList; 
static Mutex mtkSampleTableObjListLock; 

#include "include/SampleTable_mtkwrp.h"

namespace android { 

SampleTable::SampleTable(const sp<DataSource> & source)
{ 
    SampleTable_mtk* mtkInst = new SampleTable_mtk(source); 
    mtkSampleTableObjListLock.lock(); 
    mtkSampleTableObjList.add((int)this, mtkInst); 
    mtkSampleTableObjListLock.unlock(); 
} 
 
bool    SampleTable::isValid()  const
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (bool)inst->isValid(); 
} 
 
status_t    SampleTable::setChunkOffsetParams(uint32_t type,off64_t data_offset,size_t data_size)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->setChunkOffsetParams(type,data_offset,data_size); 
} 
 
status_t    SampleTable::setSampleToChunkParams(off64_t data_offset,size_t data_size)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->setSampleToChunkParams(data_offset,data_size); 
} 
 
status_t    SampleTable::setSampleSizeParams(uint32_t type,off64_t data_offset,size_t data_size)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->setSampleSizeParams(type,data_offset,data_size); 
} 
 
status_t    SampleTable::setTimeToSampleParams(off64_t data_offset,size_t data_size)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->setTimeToSampleParams(data_offset,data_size); 
} 
 
status_t    SampleTable::setCompositionTimeToSampleParams(off64_t data_offset,size_t data_size)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->setCompositionTimeToSampleParams(data_offset,data_size); 
} 
 
status_t    SampleTable::setSyncSampleParams(off64_t data_offset,size_t data_size)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->setSyncSampleParams(data_offset,data_size); 
} 
 
uint32_t    SampleTable::countChunkOffsets()  const
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (uint32_t)inst->countChunkOffsets(); 
} 
 
uint32_t    SampleTable::countSamples()  const
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (uint32_t)inst->countSamples(); 
} 
 
status_t    SampleTable::getMaxSampleSize(size_t * size)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->getMaxSampleSize(size); 
} 
 
status_t    SampleTable::getMetaDataForSample(uint32_t sampleIndex,off64_t * offset,size_t * size,uint32_t * compositionTime,bool * isSyncSample)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->getMetaDataForSample(sampleIndex,offset,size,compositionTime,isSyncSample); 
} 
 
status_t    SampleTable::findSampleAtTime(uint32_t req_time,uint32_t * sample_index,uint32_t flags)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->findSampleAtTime(req_time,sample_index,flags); 
} 
 
status_t    SampleTable::findSyncSampleNear(uint32_t start_sample_index,uint32_t * sample_index,uint32_t flags)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->findSyncSampleNear(start_sample_index,sample_index,flags); 
} 
 
status_t    SampleTable::findThumbnailSample(uint32_t * sample_index)
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjListLock.unlock(); 
    return (status_t)inst->findThumbnailSample(sample_index); 
} 
 
SampleTable::~SampleTable()
{ 
    SampleTable_mtk *inst = NULL; 
    mtkSampleTableObjListLock.lock(); 
    inst = mtkSampleTableObjList.valueFor((int)this); 
    mtkSampleTableObjList.removeItem((int)this); 
    mtkSampleTableObjListLock.unlock(); 
} 
 

}  // namespace android 
