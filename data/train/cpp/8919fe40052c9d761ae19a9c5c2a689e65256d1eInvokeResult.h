/*
 * Copyright (c) 2014-2015 TIBCO Software Inc.
 * All rights reserved.
 * For more information, please contact:
 * TIBCO Software Inc., Palo Alto, California, USA
 */

#ifndef __InvokeResult__
#define __InvokeResult__

#include "tibas.h"
#include "Exception.h"
#include "Tuple.h"
#include "Types.h"
#include "Result.h"
#include "Member.h"

namespace ASApi
{
    class AS_CPP_API InvokeResult : public Result
    {
    public:
        InvokeResult(SharedPtr<tibasInvokeResult>& invokeResult);
        InvokeResult(tibasInvokeResult& invokeResult);
        ~InvokeResult();

        const tibasInvokeResult& get() const;

        tibasInvokeResult& get();

        bool hasError() const;

        Exception getError() const;

        Status getStatus() const;

        Tuple getReturn() const;

        Member getMember() const;

    private:
        SharedPtr<tibasInvokeResult> m_invokeResult;
        tibasInvokeResult* m_invokeResultPtr;
    };
}

#endif
