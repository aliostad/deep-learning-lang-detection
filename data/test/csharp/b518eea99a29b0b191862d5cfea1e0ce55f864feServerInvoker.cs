using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using d60.Framework.Common.DI.Interface;
using d60.Framework.Server.ServerJob.Intf.Invoke;
using System.Diagnostics.Contracts;
using d60.Modules.Shared.ServerJob.Srv.Wrappers;

namespace d60.Modules.Shared.ServerJob.Srv.Invoke
{
    [RegisterType(typeof(IServerInvoker))]
    public class ServerInvoker : IServerInvoker
    {
        private readonly IWrapperFactory _factory;

        public ServerInvoker(IWrapperFactory factory)
        {
            Contract.Requires(factory != null);

            _factory = factory;
        }

        public void Invoke(IInvokeCallback callback)
        {
            InvokeWrappedMethod(_factory.Wrap(callback));
        }

        public void Invoke(IReadInvokeCallback callback)
        {
            InvokeWrappedMethod(_factory.Wrap(callback));
        }

        public void Invoke(IWriteInvokeCallback callback)
        {
            InvokeWrappedMethod(_factory.Wrap(callback));
        }

        public void Invoke<T>(IInvokeCallback<T> callback, T state)
        {
            InvokeWrappedMethod(_factory.Wrap<T>(callback, state));
        }

        public void Invoke<T>(IReadInvokeCallback<T> callback, T state)
        {
            InvokeWrappedMethod(_factory.Wrap<T>(callback, state));
        }

        public void Invoke<T>(IWriteInvokeCallback<T> callback, T state)
        {
            InvokeWrappedMethod(_factory.Wrap<T>(callback, state));
        }

        public void Invoke<T1, T2>(IInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2)
        {
            InvokeWrappedMethod(_factory.Wrap<T1, T2>(callback, arg1, arg2));
        }

        public void Invoke<T1, T2>(IReadInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2)
        {
            InvokeWrappedMethod(_factory.Wrap<T1, T2>(callback, arg1, arg2));
        }

        public void Invoke<T1, T2>(IWriteInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2)
        {
            InvokeWrappedMethod(_factory.Wrap<T1, T2>(callback, arg1, arg2));
        }

        private void InvokeWrappedMethod(IWrappedMethod method)
        {
            method.Invoke();
        }
    }
}
