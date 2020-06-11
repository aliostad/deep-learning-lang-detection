using System;

namespace ReusableLibrary.Abstractions.Models
{
    public static class DelegateInvokeStrategy
    {
        public static readonly IDelegateInvokeStrategy Publisher = new PublisherDelegateInvokeStrategy();

        public static readonly IDelegateInvokeStrategy ThreadPool = new ThreadPoolDelegateInvokeStrategy();

        public static IDelegateInvokeStrategy Synchronous
        {
            get
            {
                return new SynchronizationContextDelegateInvokeStrategy(true);
            }
        }

        public static IDelegateInvokeStrategy Asynchronous
        {
            get
            {
                return new SynchronizationContextDelegateInvokeStrategy(false);
            }
        }
    }
}
