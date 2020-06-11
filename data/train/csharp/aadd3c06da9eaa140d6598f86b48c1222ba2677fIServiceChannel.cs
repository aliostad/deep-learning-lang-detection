using System;
using System.Threading.Tasks;
using Qlue.Logging;

namespace Qlue
{
    public interface IServiceChannel : IDisposable
    {
        void StartReceiving();

        void RegisterDispatch<TRequest, TResponse>(Func<TRequest, InvokeContext, TResponse> executeAction, ILog logForDispatch = null);

        void RegisterAsyncDispatch<TRequest, TResponse>(Func<TRequest, InvokeContext, Task<TResponse>> executeAction, ILog logForDispatch = null);

        void RegisterAsyncDispatch<TRequest>(Func<TRequest, InvokeContext, Task> executeAction, ILog logForDispatch = null);

        void RegisterDispatch<TRequest>(Action<TRequest, InvokeContext> executeAction, ILog logForDispatch = null);

        void RegisterExceptionHandler(Func<Exception, Exception> exceptionHandler);
    }
}
