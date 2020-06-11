using System;
using System.Threading.Tasks;

namespace Core.Components.Pipeline
{
    public class DelegateMiddleware<TContext>: IMiddleware<TContext>
        where TContext: class, IPipeContext
    {
        private readonly Func<TContext, IPipe<TContext>, Task> invokeMethod;

        public DelegateMiddleware(Func<TContext, IPipe<TContext>, Task> invokeMethod)
        {
            this.invokeMethod = invokeMethod;
        }
        
        public Task Invoke(TContext context, IPipe<TContext> next)
        {
            return invokeMethod(context, next);
        }
    }
}