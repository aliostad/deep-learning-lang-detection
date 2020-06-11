/*
 * Copyright (c) 2014-2015 TIBCO Software Inc.
 * All rights reserved.
 * For more information, please contact:
 * TIBCO Software Inc., Palo Alto, California, USA
 */

#ifndef __InvokeResultList__
#define __InvokeResultList__

#include <vector>
#include "tibas.h"
#include "SpaceResult.h"
#include "ResultList.h"
#include "InvokeResult.h"
#include "SharedPtr.h"

namespace ASApi
{
    class AS_CPP_API InvokeResultList : public ResultList
    {
    public:
        explicit InvokeResultList(const SharedPtr<tibasInvokeResultList>& invokeResultList);
        ~InvokeResultList();
        
        bool hasError() const;
        
        Exception getError(int index) const;
        
        Status getStatus(int index) const;
        
        Tuple getReturn(int index) const;
        
        int size() const;
        
        void getReturns(std::vector<Tuple>& tuples) const;
        
        InvokeResult get(int index) const;

        void put(const InvokeResult& result) const;

    private:
        SharedPtr<tibasInvokeResultList> m_invokeResultList;
    };
}


#endif
