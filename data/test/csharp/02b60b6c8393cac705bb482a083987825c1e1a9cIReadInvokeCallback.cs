using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics.Contracts;
using d60.Framework.Server.Transaction.Interface;
using d60.Framework.Common.MessageHandler.Interface;

namespace d60.Framework.Server.ServerJob.Intf.Invoke
{
    [ContractClass(typeof(IReadInvokeCallbackContract))]
    public interface IReadInvokeCallback
    {
        void ServerInvokeCallback(IReadTransaction transaction, IMessageHandlerPublishBus bus);
    }

    [ContractClass(typeof(IReadInvokeCallbackContract<>))]
    public interface IReadInvokeCallback<T>
    {
        void ServerInvokeCallback(IReadTransaction transaction, IMessageHandlerPublishBus bus, T state);
    }

    [ContractClass(typeof(IReadInvokeCallbackContract<,>))]
    public interface IReadInvokeCallback<T1, T2>
    {
        void ServerInvokeCallback(IReadTransaction transaction, IMessageHandlerPublishBus bus, T1 arg1, T2 arg2);
    }

    [ContractClassFor(typeof(IReadInvokeCallback))]
    abstract class IReadInvokeCallbackContract : IReadInvokeCallback
    {
        void IReadInvokeCallback.ServerInvokeCallback(IReadTransaction transaction, IMessageHandlerPublishBus bus)
        {
            Contract.Requires(transaction != null);
            Contract.Requires(bus != null);
        }
    }

    [ContractClassFor(typeof(IReadInvokeCallback<>))]
    abstract class IReadInvokeCallbackContract<T> : IReadInvokeCallback<T>
    {
        void IReadInvokeCallback<T>.ServerInvokeCallback(IReadTransaction transaction, IMessageHandlerPublishBus bus, T state)
        {
            Contract.Requires(transaction != null);
            Contract.Requires(bus != null);
        }
    }

    [ContractClassFor(typeof(IReadInvokeCallback<,>))]
    abstract class IReadInvokeCallbackContract<T1, T2> : IReadInvokeCallback<T1, T2>
    {
        void IReadInvokeCallback<T1, T2>.ServerInvokeCallback(IReadTransaction transaction, IMessageHandlerPublishBus bus, T1 stateArg1, T2 stateArg2)
        {
            Contract.Requires(transaction != null);
            Contract.Requires(bus != null);
        }
    }
}
