using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics.Contracts;
using d60.Framework.Server.Transaction.Interface;
using d60.Framework.Common.MessageHandler.Interface;

namespace d60.Framework.Server.ServerJob.Intf.Invoke
{
    [ContractClass(typeof(IWriteInvokeCallbackContract))]
    public interface IWriteInvokeCallback
    {
        void ServerInvokeCallback(IWriteTransaction transaction, IMessageHandlerPublishBus bus);
    }

    [ContractClass(typeof(IWriteInvokeCallbackContract<>))]
    public interface IWriteInvokeCallback<T>
    {
        void ServerInvokeCallback(IWriteTransaction transaction, IMessageHandlerPublishBus bus, T state);
    }

    [ContractClass(typeof(IWriteInvokeCallbackContract<,>))]
    public interface IWriteInvokeCallback<T1, T2>
    {
        void ServerInvokeCallback(IWriteTransaction transaction, IMessageHandlerPublishBus bus, T1 arg1, T2 arg2);
    }

    [ContractClassFor(typeof(IWriteInvokeCallback))]
    abstract class IWriteInvokeCallbackContract : IWriteInvokeCallback
    {
        void IWriteInvokeCallback.ServerInvokeCallback(IWriteTransaction transaction, IMessageHandlerPublishBus bus)
        {
            Contract.Requires(transaction != null);
            Contract.Requires(bus != null);
        }
    }

    [ContractClassFor(typeof(IWriteInvokeCallback<>))]
    abstract class IWriteInvokeCallbackContract<T> : IWriteInvokeCallback<T>
    {
        void IWriteInvokeCallback<T>.ServerInvokeCallback(IWriteTransaction transaction, IMessageHandlerPublishBus bus, T state)
        {
            Contract.Requires(transaction != null);
            Contract.Requires(bus != null);
        }
    }

    [ContractClassFor(typeof(IWriteInvokeCallback<,>))]
    abstract class IWriteInvokeCallbackContract<T1, T2> : IWriteInvokeCallback<T1, T2>
    {
        void IWriteInvokeCallback<T1, T2>.ServerInvokeCallback(IWriteTransaction transaction, IMessageHandlerPublishBus bus, T1 arg1, T2 arg2)
        {
            Contract.Requires(transaction != null);
            Contract.Requires(bus != null);
        }
    }
}
