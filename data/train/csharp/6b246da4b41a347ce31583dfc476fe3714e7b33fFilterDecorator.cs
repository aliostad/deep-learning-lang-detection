namespace Serpent.Common.MessageBus.MessageHandlerChain.Decorators.Filter
{
    using System;
    using System.Threading;
    using System.Threading.Tasks;

    internal class FilterDecorator<TMessageType> : MessageHandlerChainDecorator<TMessageType>
    {
        private readonly Func<TMessageType, CancellationToken, Task> handlerFunc;

        private readonly Func<TMessageType, CancellationToken, Task<bool>> beforeInvoke;

        private readonly Func<TMessageType, CancellationToken, Task> afterInvoke;

        public FilterDecorator(Func<TMessageType, CancellationToken, Task> handlerFunc, Func<TMessageType, CancellationToken, Task<bool>> beforeInvoke = null, Func<TMessageType, CancellationToken, Task> afterInvoke = null)
        {
            this.handlerFunc = handlerFunc;
            this.beforeInvoke = beforeInvoke;
            this.afterInvoke = afterInvoke;
        }

        public override async Task HandleMessageAsync(TMessageType message, CancellationToken token)
        {
            bool invoke = false;

            if (this.beforeInvoke != null)
            {
                invoke = await this.beforeInvoke(message, token).ConfigureAwait(false);
            }

            if (invoke)
            {
                await this.handlerFunc(message, token).ConfigureAwait(false);
            }

            if (this.afterInvoke != null)
            {
                await this.afterInvoke(message, token).ConfigureAwait(false);
            }
        }
    }
}