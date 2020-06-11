namespace Bartender
{
    /// <summary>
    /// Define a dispatcher
    /// </summary>
    public interface IDispatcher
    {
        /// <summary>
        /// Dispatch a message
        /// </summary>
        /// <param name="message">Message to dispatch</param>
        /// <returns>Result</returns>
        TResult Dispatch<TMessage, TResult>(TMessage message) 
            where TMessage : IMessage;

        /// <summary>
        /// Dispatch the specified message.
        /// </summary>
        /// <param name="message">Message.</param>
        void Dispatch<TMessage>(TMessage message) 
            where TMessage : IMessage;
    }
}

