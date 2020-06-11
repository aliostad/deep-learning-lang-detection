using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using d60.Framework.Server.ServerJob.Intf.Invoke;
using d60.Framework.Common.MessageHandler.Interface;

namespace d60.Modules.Shared.ServerJob.Srv.Wrappers
{
    class InvokeCallbackWrapper : IWrapper
    {
        private IInvokeCallback _callback;

        public InvokeCallbackWrapper(IInvokeCallback callback)
        {
            _callback = callback;
        }

        public void Invoke(IMessageHandlerPublishBus bus)
        {
            _callback.ServerInvokeCallback(bus);
        }
    }

    class InvokeCallbackWrapper<T> : IWrapper
    {
        private IInvokeCallback<T> _callback;
        private T _arg;

        public InvokeCallbackWrapper(IInvokeCallback<T> callback, T arg)
        {
            _callback = callback;
            _arg = arg;
        }

        public void Invoke(IMessageHandlerPublishBus bus)
        {
            _callback.ServerInvokeCallback(bus, _arg);
        }
    }

    class InvokeCallbackWrapper<T1, T2> : IWrapper
    {
        private IInvokeCallback<T1, T2> _callback;
        private T1 _arg1;
        private T2 _arg2;

        public InvokeCallbackWrapper(IInvokeCallback<T1, T2> callback, T1 arg1, T2 arg2)
        {
            _callback = callback;
            _arg1 = arg1;
            _arg2 = arg2;
        }

        public void Invoke(IMessageHandlerPublishBus bus)
        {
            _callback.ServerInvokeCallback(bus, _arg1, _arg2);
        }
    }
}
