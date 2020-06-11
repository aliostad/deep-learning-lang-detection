using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics.Contracts;

namespace d60.Framework.Server.ServerJob.Intf.Invoke
{
    [ContractClass(typeof(IServerInvokerContract))]
    public interface IServerInvoker
    {
        void Invoke(IInvokeCallback callback);
        void Invoke(IReadInvokeCallback callback);
        void Invoke(IWriteInvokeCallback callback);

        void Invoke<T>(IInvokeCallback<T> callback, T state);
        void Invoke<T>(IReadInvokeCallback<T> callback, T state);
        void Invoke<T>(IWriteInvokeCallback<T> callback, T state);

        void Invoke<T1, T2>(IInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2);
        void Invoke<T1, T2>(IReadInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2);
        void Invoke<T1, T2>(IWriteInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2);
    }

    [ContractClassFor(typeof(IServerInvoker))]
    abstract class IServerInvokerContract : IServerInvoker
    {
        void IServerInvoker.Invoke(IInvokeCallback callback)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke(IReadInvokeCallback callback)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke(IWriteInvokeCallback callback)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke<T>(IInvokeCallback<T> callback, T state)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke<T>(IReadInvokeCallback<T> callback, T state)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke<T>(IWriteInvokeCallback<T> callback, T state)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke<T1, T2>(IInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke<T1, T2>(IReadInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2)
        {
            Contract.Requires(callback != null);
        }

        void IServerInvoker.Invoke<T1, T2>(IWriteInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2)
        {
            Contract.Requires(callback != null);
        }
    }
}
