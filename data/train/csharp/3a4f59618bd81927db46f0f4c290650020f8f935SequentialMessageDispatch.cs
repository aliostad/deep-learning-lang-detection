using System;
using Disruptor;

namespace Messaging.Consumer
{
    /// <summary>
    /// Simple IBatchHandler Implementation to sequentially notify a single consumer.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    internal sealed class SequentialMessageDispatch<T> : IBatchHandler<T>
        where T : class
    {
        Action<T> _dispatchCallBack;

        internal SequentialMessageDispatch(Action<T> dispatchCallBack) 
        {
            _dispatchCallBack = dispatchCallBack ?? delegate { };
        }

        void IBatchHandler<T>.OnAvailable(long sequence, T data)
        {
            _dispatchCallBack(data);
        }

        void IBatchHandler<T>.OnEndOfBatch()
        {
        }
    }
}




