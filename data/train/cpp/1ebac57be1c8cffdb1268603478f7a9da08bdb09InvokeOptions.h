/*
 * Copyright (c) 2014-2015 TIBCO Software Inc.
 * All rights reserved.
 * For more information, please contact:
 * TIBCO Software Inc., Palo Alto, California, USA
 */

#ifndef __InvokeOptions__
#define __InvokeOptions__

#include "tibas.h"
#include "SpaceOptions.h"
#include "Tuple.h"

namespace ASApi
{
    class AS_CPP_API InvokeOptions : public SpaceOptions<InvokeOptions, tibasInvokeOptions>
    {
    public:
        InvokeOptions();
        
        InvokeOptions& setContext(const Tuple& context);
    };
}

#endif
