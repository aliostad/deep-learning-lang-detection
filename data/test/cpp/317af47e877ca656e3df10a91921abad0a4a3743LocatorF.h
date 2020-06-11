// **********************************************************************
//
// Copyright (c) 2003-2009 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

// Ice version 3.3.1
// Generated from file `LocatorF.ice'

#ifndef __Ice_LocatorF_h__
#define __Ice_LocatorF_h__

#include <Ice/LocalObjectF.h>
#include <Ice/ProxyF.h>
#include <Ice/ObjectF.h>
#include <Ice/Exception.h>
#include <Ice/LocalObject.h>
#include <Ice/Proxy.h>
#include <Ice/Object.h>
#include <Ice/UndefSysMacros.h>

#ifndef ICE_IGNORE_VERSION
#   if ICE_INT_VERSION / 100 != 303
#       error Ice version mismatch!
#   endif
#   if ICE_INT_VERSION % 100 > 50
#       error Beta header file detected
#   endif
#   if ICE_INT_VERSION % 100 < 1
#       error Ice patch level mismatch!
#   endif
#endif

#ifndef ICE_API
#   ifdef ICE_API_EXPORTS
#       define ICE_API ICE_DECLSPEC_EXPORT
#   else
#       define ICE_API ICE_DECLSPEC_IMPORT
#   endif
#endif

namespace IceProxy
{

namespace Ice
{

class Locator;

class LocatorRegistry;

}

}

namespace Ice
{

class Locator;
ICE_API bool operator==(const Locator&, const Locator&);
ICE_API bool operator<(const Locator&, const Locator&);

class LocatorRegistry;
ICE_API bool operator==(const LocatorRegistry&, const LocatorRegistry&);
ICE_API bool operator<(const LocatorRegistry&, const LocatorRegistry&);

}

namespace IceInternal
{

ICE_API ::Ice::Object* upCast(::Ice::Locator*);
ICE_API ::IceProxy::Ice::Object* upCast(::IceProxy::Ice::Locator*);

ICE_API ::Ice::Object* upCast(::Ice::LocatorRegistry*);
ICE_API ::IceProxy::Ice::Object* upCast(::IceProxy::Ice::LocatorRegistry*);

}

namespace Ice
{

typedef ::IceInternal::Handle< ::Ice::Locator> LocatorPtr;
typedef ::IceInternal::ProxyHandle< ::IceProxy::Ice::Locator> LocatorPrx;

ICE_API void __read(::IceInternal::BasicStream*, LocatorPrx&);
ICE_API void __patch__LocatorPtr(void*, ::Ice::ObjectPtr&);

typedef ::IceInternal::Handle< ::Ice::LocatorRegistry> LocatorRegistryPtr;
typedef ::IceInternal::ProxyHandle< ::IceProxy::Ice::LocatorRegistry> LocatorRegistryPrx;

ICE_API void __read(::IceInternal::BasicStream*, LocatorRegistryPrx&);
ICE_API void __patch__LocatorRegistryPtr(void*, ::Ice::ObjectPtr&);

}

#endif
