
//*****************************************************************************
// RCF - Remote Call Framework
// Copyright (c) 2005. All rights reserved.
// Developed by Jarl Lindrud.
// Contact: jlindrud@hotmail.com .
//*****************************************************************************

#ifndef _RCF_SERVERSTUB_INL_
#define _RCF_SERVERSTUB_INL_

#include <RCF/ServerStub.hpp>
#include <RCF/util/Meta.hpp>

namespace RCF {

    template<typename StubT, typename IdT, typename T>
    void StubAccess::invoke(StubT &stub, const IdT &id, Connection &connection, T &t)
    {
        stub.invoke(id, connection, t);
    }

    template<typename StubT, typename ImplementationT>
    ServerStub<StubT, ImplementationT>::ServerStub(ImplementationT &x) : 
            px(),
            x(x)
    {}

    template<typename StubT, typename ImplementationT>
    ServerStub<StubT, ImplementationT>::ServerStub(std::auto_ptr<ImplementationT> px) : 
            px(px.release()),
            x(*this->px)
    {}

    template<typename StubT, typename ImplementationT>
        ServerStub<StubT, ImplementationT>::ServerStub(boost::shared_ptr<ImplementationT> px) : 
            px(px),
            x(*px)
    {}

    template<typename StubT, typename ImplementationT>
    void ServerStub<StubT, ImplementationT>::invoke(int id, RCF::Connection &connection)
    {
        RCF_TRACE("")(id);

        switch (id) {
            case  0: invoke( stub, Meta::Int< 0>(), connection, x ); break;
            case  1: invoke( stub, Meta::Int< 1>(), connection, x ); break;
            case  2: invoke( stub, Meta::Int< 2>(), connection, x ); break;
            case  3: invoke( stub, Meta::Int< 3>(), connection, x ); break;
            case  4: invoke( stub, Meta::Int< 4>(), connection, x ); break;
            case  5: invoke( stub, Meta::Int< 5>(), connection, x ); break;
            case  6: invoke( stub, Meta::Int< 6>(), connection, x ); break;
            case  7: invoke( stub, Meta::Int< 7>(), connection, x ); break;
            case  8: invoke( stub, Meta::Int< 8>(), connection, x ); break;
            case  9: invoke( stub, Meta::Int< 9>(), connection, x ); break;
            case 10: invoke( stub, Meta::Int<10>(), connection, x ); break;
            case 11: invoke( stub, Meta::Int<11>(), connection, x ); break;
            case 12: invoke( stub, Meta::Int<12>(), connection, x ); break;
            case 13: invoke( stub, Meta::Int<13>(), connection, x ); break;
            case 14: invoke( stub, Meta::Int<14>(), connection, x ); break;
            case 15: invoke( stub, Meta::Int<15>(), connection, x ); break;
            case 16: invoke( stub, Meta::Int<16>(), connection, x ); break;
            case 17: invoke( stub, Meta::Int<17>(), connection, x ); break;
            case 18: invoke( stub, Meta::Int<18>(), connection, x ); break;
            case 19: invoke( stub, Meta::Int<19>(), connection, x ); break;
            case 20: invoke( stub, Meta::Int<20>(), connection, x ); break;
            case 21: invoke( stub, Meta::Int<21>(), connection, x ); break;
            case 22: invoke( stub, Meta::Int<22>(), connection, x ); break;
            case 23: invoke( stub, Meta::Int<23>(), connection, x ); break;
            case 24: invoke( stub, Meta::Int<24>(), connection, x ); break;
            case 25: invoke( stub, Meta::Int<25>(), connection, x ); break;

            default: RCF_ASSERT(0);
        }
    }

    template<typename StubT, typename ImplementationT>
    template<typename IdT>
    void ServerStub<StubT, ImplementationT>::invoke(StubT &stub, const IdT &id, Connection &connection, ImplementationT &t)
    {
        StubAccess().invoke(stub, id, connection, t);
    }
    
    template<typename StubT, typename ImplementationT>
    Token ServerStub<StubT, ImplementationT>::getToken() 
    { 
        return token; 
    }
    
    template<typename StubT, typename ImplementationT>
    void ServerStub<StubT, ImplementationT>::setToken(Token token) 
    { 
        this->token = token; 
    }

} // namespace RCF

#endif // ! _RCF_SERVERSTUB_INL_
