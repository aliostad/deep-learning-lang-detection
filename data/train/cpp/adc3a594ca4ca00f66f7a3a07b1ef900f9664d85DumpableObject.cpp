#include "Import.h"
#include "DumpableObject.h"

#include "DumpToString.h"
#include "LevelValue.h"
#include "String.h"
#include "CtrlRef.h"
#include "SetDumpStringQueueEntry.h"
#include <thread>

using namespace HWLib;

DumpableObject::DumpableObject() 
: isDumpStringValid(false)
, dumpString("")
, dumpShortString("")
, isInDump(false)
, SetDumpStringToDo(nullptr)
{};

DumpableObject::DumpableObject(DumpableObject const&other)
: isDumpStringValid(other.isDumpStringValid)
, dumpString(other.dumpString)
, dumpShortString(other.dumpShortString)
, isInDump(false)
, SetDumpStringToDo(nullptr)
{};


DumpableObject::~DumpableObject(){
    SetDumpStringQueueEntry::Remove(SetDumpStringToDo);
}

bool DumpableObject::EnableSetDumpString = false;
bool DumpableObject::EnableSetDumpStringAsync = true;

void DumpableObject::SetDumpString(){
    if(!c_.IsDebuggerPresent)
        return;
    
    if(!EnableSetDumpString)
        return;
    
    if(EnableSetDumpStringAsync)
        SetDumpStringToDo = SetDumpStringQueueEntry::Insert(*this);
    else
        SetDumpStringWorker();
}

void DumpableObject::SetDumpStringQueueEntryWait(){
    SetDumpStringQueueEntry::Wait();
}

String const DumpableObject::SetDumpStringWorker(){
    dumpString = DumpLong.RawData;
    dumpShortString = DumpShort.RawData;
    isDumpStringValid = true;
    return dumpString;
}

p_implementation(DumpableObject, String, Dump){
    return DumpLong;
}

p_virtual_header_implementation(DumpableObject, String, DumpHeader);

p_implementation(DumpableObject, String, DumpHeader){return HWLib::DumpTypeName(*this);};

p_implementation(DumpableObject, String, DumpLong){
    auto result = DumpHeader;
    Array<String> dataResult { "..." };

    if (!isInDump)
    {
        LevelValue<bool> inDump (isInDump, true);
        dataResult = DumpData;
    }
    
    return DumpHeader + String::Surround("{", dataResult, "}");
};

p_virtual_implementation(DumpableObject, String, DumpShort){
    return DumpHeader;
};

p_virtual_header_implementation(DumpableObject, Array<String>, DumpData);

#include "TemplateInstances.h"
