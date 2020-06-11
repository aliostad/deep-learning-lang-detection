/*
 * Copyright (c) 2014-2015 TIBCO Software Inc.
 * All rights reserved.
 * For more information, please contact:
 * TIBCO Software Inc., Palo Alto, California, USA
 */

#include "InvokeOptions.h"
#include "options.h"
#include "Exception.h"

using namespace std;
using namespace ASApi;


InvokeOptions::InvokeOptions()
    : SpaceOptions<ASApi::InvokeOptions, tibasInvokeOptions>(tibasInvokeOptions_Initialize)
{
    
}


InvokeOptions& InvokeOptions::setContext(const Tuple& context)
{
    m_options->context = context.get();
    return *this;
}


