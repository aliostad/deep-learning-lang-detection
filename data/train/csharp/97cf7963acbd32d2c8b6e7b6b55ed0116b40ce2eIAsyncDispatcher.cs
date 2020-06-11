using System.Threading.Tasks;

namespace Bartender
{
    /// <summary>
    /// Define an asynchronous dispatcher
    /// </summary>
    public interface IAsyncDispatcher
    {
        /// <summary>
        /// Dispatch a message asynchronously.
        /// </summary>
        /// <param name="message">Message to dispatch</param>
        /// <returns>Result</returns>
        Task<TResult> DispatchAsync<TMessage, TResult>(TMessage message)
            where TMessage : IMessage;

        /// <summary>
        /// Dispatch a message asynchronously.
        /// </summary>
        /// <param name="message">Message to dispatch</param>
        Task DispatchAsync<TMessage>(TMessage message)
            where TMessage : IMessage;
    }
}

