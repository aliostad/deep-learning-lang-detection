/*
 * Copyright (c) 2014-2015 TIBCO Software Inc.
 * All rights reserved.
 * For more information, please contact:
 * TIBCO Software Inc., Palo Alto, California, USA
 */

#include "InvokeResult.h"
#include "Utils.h"

using namespace ASApi;

InvokeResult::InvokeResult(SharedPtr<tibasInvokeResult>& invokeResult)
: m_invokeResult(invokeResult),
  m_invokeResultPtr(m_invokeResult.get())
{
}


InvokeResult::InvokeResult(tibasInvokeResult& invokeResult)
: m_invokeResultPtr(&invokeResult)
{
}


InvokeResult::~InvokeResult()
{
    
}


const tibasInvokeResult& InvokeResult::get() const
{
 return *m_invokeResult;
}


tibasInvokeResult& InvokeResult::get()
{
 return *m_invokeResult;
}


bool InvokeResult::hasError() const
{
    tibas_boolean isError = TIBAS_FALSE;
    isError = tibasInvokeResult_HasError(*m_invokeResultPtr);

    if(isError == TIBAS_FALSE)
    {
        return false;
    }
    else
    {
        return true;
    }
}


Status InvokeResult::getStatus() const
{
    Status status = TIBAS_OK;
    AS_CALL(tibasInvokeResult_GetStatus(*m_invokeResultPtr, &status));
    return status;
}


Exception InvokeResult::getError() const
{
    SharedPtr<tibasError> error (new tibasError(), Deleter<tibasError>(tibasError_Free));
    AS_CALL(tibasInvokeResult_GetError(*m_invokeResultPtr, error.get()));
    return Exception(error);
}


Tuple InvokeResult::getReturn() const
{
    SharedPtr<tibasTuple> tuple (new tibasTuple(), Deleter<tibasTuple>(tibasTuple_Free));
    AS_CALL(tibasInvokeResult_GetReturn(*m_invokeResultPtr, tuple.get()));
    return Tuple(tuple);
}


Member InvokeResult::getMember() const
{
    SharedPtr<tibasMember> member (new tibasMember(), Deleter<tibasMember>(tibasMember_Free));
    AS_CALL(tibasInvokeResult_GetMember(*m_invokeResultPtr, member.get()));
    return Member(member);
}
